#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/fcntl.h"
#include "kernel/param.h"
#include "user/user.h"

// 用于读取一行输入
void readline(char *buf, int size) {
  int i = 0;
  char c;
  while (i < size - 1) {
    if (read(0, &c, 1) != 1 || c == '\n') {//从标准输入读取一个字符
      break;
    }
    buf[i++] = c;
  }
  buf[i] = '\0';
}

int main(int argc, char *argv[]) {
  if (argc < 2) {
    fprintf(2, "Usage: %s <command>\n", argv[0]);
    exit(1);
  }
  char buf[512];
  char *cmd = argv[1];
  char *args[MAXARG];//利用kernel/param.h中定义
  // 将命令行参数复制到args数组中
  for (int i = 0; i < argc - 1; i++) {
    args[i] = argv[i + 1];
    // printf("%s",argv[i+1]);
  }
  args[argc] = 0; // 设置最后一个参数为NULL
  while (1) {
    readline(buf, sizeof(buf));
    if (buf[0] == '\0') { // 读取到文件结尾
      break;
    }
    if (fork() == 0) { // 子进程
      args[argc - 1] = buf; // 将输入行作为参数拼接到最后
      exec(cmd, args);
      fprintf(2, "exec %s failed\n", cmd); // exec失败时返回
      exit(1);
    } else { // 父进程
      wait(0); // 等待子进程完成
    }
  }
  exit(0);
}
