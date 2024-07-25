// Buffer cache.
//
// The buffer cache is a linked list of buf structures holding
// cached copies of disk block contents.  Caching disk blocks
// in memory reduces the number of disk reads and also provides
// a synchronization point for disk blocks used by multiple processes.
//
// Interface:
// * To get a buffer for a particular disk block, call bread.
// * After changing buffer data, call bwrite to write it to disk.
// * When done with the buffer, call brelse.
// * Do not use the buffer after calling brelse.
// * Only one process at a time can use a buffer,
//     so do not keep them longer than necessary.


#include "types.h"
#include "param.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "riscv.h"
#include "defs.h"
#include "fs.h"
#include "buf.h"

#define NBUK  13
#define hash(dev, blockno) ((dev * blockno) % NBUK)

struct bucket
{
  struct spinlock lock;
  struct buf head;
};


struct {
  struct spinlock lock; // 主要保护的是连接所有槽位的链表。
  struct buf buf[NBUF]; // 代表我们有30个槽位可用。

  // Linked list of all buffers, through prev/next.
  // Sorted by how recently the buffer was used.
  // head.next is most recent, head.prev is least.
  //struct buf head;
  struct bucket buckets[NBUK]; // the cache has 13 buckets
} bcache;

void
binit(void)
{
  struct buf *b;
  struct buf *prev_b;

  initlock(&bcache.lock, "bcache");
  // 将所有的 buf 都先放到 buckets[0] 中
  for(int i=0; i<NBUK; i++)
  {
    initlock(&bcache.buckets[i].lock, "bcache.bucket");
    bcache.buckets[i].head.next = (void *)0;
    if(i == 0)
    {
      prev_b = &bcache.buckets[i].head;
      for(b = bcache.buf; b < bcache.buf+NBUF; b++)
      {
        if(b == bcache.buf + NBUF - 1)//最后一个
        {
          b->next = (void*)0;
        }
        prev_b->next = b;
        b->timestamp = ticks; // 初始化时间戳
        initsleeplock(&b->lock, "buffer");
        prev_b = b; 
      }
    }
  }
}

//用于获取指定设备号和块号的缓冲区
//先在对应的桶中查找是否已有缓存，如果有则返回。
//如果没有找到，遍历所有桶，找到最近使用最少的缓冲区（基于时间戳）。
//将找到的缓冲区从原桶移除，并插入到新桶中。
//更新缓冲区的设备号、块号等信息并返回。
static struct buf *
bget(uint dev, uint blockno)
{
  struct buf *b;
  int buk_id = hash(dev, blockno);
  // 获取对应桶的锁
  acquire(&bcache.buckets[buk_id].lock);
  // 在桶中查找是否已有缓存
  for (b = bcache.buckets[buk_id].head.next; b; b=b->next)
  {
    if(b->dev == dev && b->blockno == blockno)
    {
      b->refcnt++;
      release(&bcache.buckets[buk_id].lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  // 释放锁，因为没有找到缓存
  release(&bcache.buckets[buk_id].lock);
  int max_timestamp = 0;
  int lru_buk_id = -1;
  int is_better = 0; //是否有更好的lru_buk_id
  struct buf *lru_b = (void*)0;
  struct buf *prev_lru_b = (void*)0;
  struct buf *prev_b = (void*)0;
  // 遍历所有桶，寻找最近最少使用的缓冲区
  for(int i=0; i<NBUK; ++i)
  {
    prev_b = &bcache.buckets[i].head;
    acquire(&bcache.buckets[i].lock);
    while(prev_b->next)
    {
      if (prev_b->next->refcnt == 0 && prev_b->next->timestamp >= max_timestamp)
      {
        max_timestamp = prev_b->next->timestamp;
        is_better = 1;
        prev_lru_b = prev_b;
      }
      prev_b = prev_b->next;
    }
    if(is_better)
    {
      if(lru_buk_id != -1)
      {
        release(&bcache.buckets[lru_buk_id].lock);
      }
      lru_buk_id = i;
    }
    else{
      release(&bcache.buckets[i].lock);
    }
    is_better = 0;
  }

  //get lru_b
  lru_b = prev_lru_b->next;

  // 从原桶中移除该缓冲区
  if (lru_b)
  {
    prev_lru_b->next = prev_lru_b->next->next;
    release(&bcache.buckets[lru_buk_id].lock);
  }
  acquire(&bcache.lock);
  acquire(&bcache.buckets[buk_id].lock);
  // 将找到的缓冲区插入到新桶中
  if (lru_b)
  {
    lru_b->next = bcache.buckets[buk_id].head.next;
    bcache.buckets[buk_id].head.next = lru_b;
  }
  b = bcache.buckets[buk_id].head.next; // buckets[buk_id]中的第一个buf。
  // 在新桶中查找指定的缓冲区
  while (b)
  {
    if (b->dev == dev && b->blockno == blockno)
    {
      b->refcnt++;
      release(&bcache.buckets[buk_id].lock);
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
    b = b->next;
  }
  // 在遍历每个桶的时候找不到lru_b
  if (lru_b == 0)
    panic("bget: no buffers");
// 更新缓冲区的信息
  lru_b->dev = dev;
  lru_b->blockno = blockno;
  lru_b->valid = 0;
  lru_b->refcnt = 1;
  release(&bcache.buckets[buk_id].lock);
  release(&bcache.lock);
  acquiresleep(&lru_b->lock);
  return lru_b;
}
//返回锁定的缓冲区，如果缓冲区内容无效，则从磁盘读取数据。
// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno); // 通过调用bget来获取指定磁盘块的缓存块
  if(!b->valid) {
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b; // 返回的是上锁的且可用的缓存块。
}
//将缓冲区内容写入磁盘，必须持有缓冲区的锁。
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  virtio_disk_rw(b, 1);
}
//释放缓冲区，减少引用计数，如果引用计数为0，则更新时间戳
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
  releasesleep(&b->lock);

  int buk_id = hash(b->dev, b->blockno);
  acquire(&bcache.buckets[buk_id].lock);
  b->refcnt--; // 减去引用计数refcnt
  if (b->refcnt == 0) {
    b->timestamp = ticks;
  }
  release(&bcache.buckets[buk_id].lock);
}
//bpin 和 bunpin 分别增加和减少缓冲区的引用计数，用于防止缓冲区在某些关键操作期间被回收。
void 
bpin(struct buf *b)
{
  int buk_id = hash(b->dev, b->blockno);
  acquire(&bcache.buckets[buk_id].lock);
  b->refcnt++;
  release(&bcache.buckets[buk_id].lock);
}

void 
bunpin(struct buf *b)
{
  int buk_id = hash(b->dev, b->blockno);
  acquire(&bcache.buckets[buk_id].lock);
  b->refcnt--;
  release(&bcache.buckets[buk_id].lock);
}