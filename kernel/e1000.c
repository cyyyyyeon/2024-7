#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"
#include "e1000_dev.h"
#include "net.h"

#define TX_RING_SIZE 16
static struct tx_desc tx_ring[TX_RING_SIZE] __attribute__((aligned(16)));
static struct mbuf *tx_mbufs[TX_RING_SIZE];

#define RX_RING_SIZE 16
static struct rx_desc rx_ring[RX_RING_SIZE] __attribute__((aligned(16)));
static struct mbuf *rx_mbufs[RX_RING_SIZE];

// remember where the e1000's registers live.
static volatile uint32 *regs;

struct spinlock e1000_lock;

// called by pci_init().
// xregs is the memory address at which the
// e1000's registers are mapped.
void
e1000_init(uint32 *xregs)
{
  int i;

  initlock(&e1000_lock, "e1000");//初始化锁

  regs = xregs;//初始化寄存器指针

  // Reset the device
  regs[E1000_IMS] = 0; // disable interrupts
  regs[E1000_CTL] |= E1000_CTL_RST;// 复位控制寄存器
  regs[E1000_IMS] = 0; // redisable interrupts
  __sync_synchronize();
  //初始化传输环
  // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
  for (i = 0; i < TX_RING_SIZE; i++) {
    tx_ring[i].status = E1000_TXD_STAT_DD;// 标记描述符为空闲
    tx_mbufs[i] = 0;
  }
  regs[E1000_TDBAL] = (uint64) tx_ring;// 设置传输环的基地址
  if(sizeof(tx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring); // 设置传输环的长度
  regs[E1000_TDH] = regs[E1000_TDT] = 0; // 设置头部和尾部指针
  //初始化接收环
  // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));// 分配 mbuf
  for (i = 0; i < RX_RING_SIZE; i++) {
    rx_mbufs[i] = mbufalloc(0);
    if (!rx_mbufs[i])
      panic("e1000");
    rx_ring[i].addr = (uint64) rx_mbufs[i]->head;// 设置描述符地址
  }
  regs[E1000_RDBAL] = (uint64) rx_ring; // 设置接收环的基地址
  if(sizeof(rx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_RDH] = 0;// 设置头部指针
  regs[E1000_RDT] = RX_RING_SIZE - 1; // 设置尾部指针
  regs[E1000_RDLEN] = sizeof(rx_ring);// 设置接收环的长度
  //设置 MAC 地址和多播表
  // filter by qemu's MAC address, 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;//mac低32位
  regs[E1000_RA+1] = 0x5634 | (1<<31);//高16位
  // multicast table
  for (int i = 0; i < 4096/32; i++)
    regs[E1000_MTA + i] = 0;

  // transmitter control bits.
  regs[E1000_TCTL] = E1000_TCTL_EN |  // enable
    E1000_TCTL_PSP |                  // pad short packets
    (0x10 << E1000_TCTL_CT_SHIFT) |   // collision stuff
    (0x40 << E1000_TCTL_COLD_SHIFT);
  regs[E1000_TIPG] = 10 | (8<<10) | (6<<20); // inter-pkt gap

  // receiver control bits.
  regs[E1000_RCTL] = E1000_RCTL_EN | // enable receiver
    E1000_RCTL_BAM |                 // enable broadcast
    E1000_RCTL_SZ_2048 |             // 2048-byte rx buffers
    E1000_RCTL_SECRC;                // strip CRC
  //启用接收中断
  // ask e1000 for receive interrupts.
  regs[E1000_RDTR] = 0; // interrupt after every received packet (no timer)
  regs[E1000_RADV] = 0; // interrupt after every packet (no timer)
  regs[E1000_IMS] = (1 << 7); // RXDW -- Receiver Descriptor Write Back
}

int
e1000_transmit(struct mbuf *m)
{
  //
  // Your code here.
  //
  // the mbuf contains an ethernet frame; program it into
  // the TX descriptor ring so that the e1000 sends it. Stash
  // a pointer so that it can be freed after sending.
  //
  acquire(&e1000_lock);

  uint32 tdt = regs[E1000_TDT]; // 获取当前尾部指针
  struct tx_desc *desc = &tx_ring[tdt]; // 获取当前描述符

  // 检查描述符是否可用
  if (!(desc->status & E1000_TXD_STAT_DD)) {
    release(&e1000_lock);
    return -1; // 环已满，无法传输
  }

  // 设置描述符地址和长度
  desc->addr = (uint64)m->head;
  desc->length = m->len;
  desc->cmd = E1000_TXD_CMD_RS | E1000_TXD_CMD_EOP; // 设置命令（请求状态和数据包结束）

  // 保存 mbuf 以便稍后释放
  if (tx_mbufs[tdt])
    mbuffree(tx_mbufs[tdt]);
  tx_mbufs[tdt] = m;

  // 更新尾部指针
  regs[E1000_TDT] = (tdt + 1) % TX_RING_SIZE;

  release(&e1000_lock);
  return 0;
}

static void
e1000_recv(void)
{
  //
  // Your code here.
  //
  // Check for packets that have arrived from the e1000
  // Create and deliver an mbuf for each packet (using net_rx()).
  //
  // acquire(&e1000_lock);

  uint32 rdt = regs[E1000_RDT]; // 获取当前尾部指针
  uint32 rdh = regs[E1000_RDH]; // 获取当前头部指针

  while (rdh != (rdt + 1) % RX_RING_SIZE) {
    struct rx_desc *desc = &rx_ring[(rdt + 1) % RX_RING_SIZE];

    // 检查描述符是否包含有效数据包
    if (!(desc->status & E1000_RXD_STAT_DD)) {
      return;
    }

    // 提取接收的数据包
    struct mbuf *m = rx_mbufs[(rdt + 1) % RX_RING_SIZE];
    m->len = desc->length;

    // 传递给网络栈
    net_rx(m);

    // 分配新的 mbuf 并更新描述符
    struct mbuf *new_mbuf = mbufalloc(0);
    if (!new_mbuf)
      panic("e1000");
    rx_mbufs[(rdt + 1) % RX_RING_SIZE] = new_mbuf;
    desc->addr = (uint64)new_mbuf->head;
    desc->status = 0;

    rdt = (rdt + 1) % RX_RING_SIZE;
  }

  // 更新尾部指针
  regs[E1000_RDT] = rdt;

  // release(&e1000_lock);
}

void
e1000_intr(void)
{
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;

  e1000_recv();
}
