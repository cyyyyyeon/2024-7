#include <kernel/types.h>
#include <user/user.h>
int main(){
    //0代表读，1代表写
    int parent[2],child[2];
    //父进程写，子进程读
    pipe(parent);
    //子进程写，父进程读
    pipe(child);
    char buffer[1]={'a'};//一个字节长度
    long length=sizeof (buffer);
    //子进程
    if(fork() == 0){
        //关掉不用的parent[1]、child[0]
        close(parent[1]);
        close(child[0]);
		//子进程从parent的读端读
		if(read(parent[0], buffer, length) != length){
			printf("a--->b read error!");
			exit(1);
		}
		printf("%d: received ping\n", getpid());
		//子进程向child的写端写
		if(write(child[1], buffer, length) != length){
			printf("a<---b write error!");
			exit(1);
		}
        exit(0);
    }
    //父进程
    close(parent[0]);
    close(child[1]);
	if(write(parent[1], buffer, length) != length){
		printf("a--->b write error!");
		exit(1);
	}
	if(read(child[0], buffer, length) != length){
		printf("a<---b read error!");
		exit(1);
	}
	printf("%d: received pong\n", getpid());
    //等待进程子退出
    wait(0);
	exit(0);
}
