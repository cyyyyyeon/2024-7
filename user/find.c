#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fs.h"
#include "user/user.h"
//把路径转化为文件名
char* fmtname(char *path)
{
  static char buf[DIRSIZ+1];
  char *p;
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    ;
  p++;
  memmove(buf, p, strlen(p)+1);//复制末尾空字符
  return buf;
}
void find(char *path,char *filename){
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  if((fd = open(path, 0)) < 0){
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }
  if(fstat(fd, &st) < 0){
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }
  switch(st.type){
  case T_FILE:
    if(strcmp(fmtname(path),filename)==0){
        printf("%s\n",path);
    }
    break;
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
      printf("ls: path too long\n");
      break;
    }
    strcpy(buf, path);
    p = buf+strlen(buf);
    *p++ = '/';
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
      // 跳过无效目录项（inum 为 0 或 1，或者是当前目录"."或父目录".."）
      if(de.inum == 0 ||strcmp(de.name, ".")==0|| strcmp(de.name, "..")==0)
        continue;
      memmove(p, de.name, strlen(de.name));
      p[strlen(de.name)] = 0;
	    find(buf, filename);    
    }
    break;
  }
  close(fd);
}

int main(int argc,char *argv[]){
  //检查参数
  if(argc!=3){
    fprintf(2,"usage:find <path> <filename>\n");
    exit(1);
  }
  find(argv[1],argv[2]);
  exit(0);
}