#include <kernel/types.h>
#include <user/user.h>
int main(){
    int p1[2];
    pipe(p1);
    if(fork()>0){
        //写入2-35
        for(int i=2;i<=35;i++){
            write(p1[1],&i,sizeof(i));
        }
        //关闭写端
        close(p1[1]);
        wait(0);
    }
    else{
        //子进程循环
        while(1){
            int n,prime,p2[2];
            close(p1[1]);
            //如果还有数字可读,读取首个数字作为素数：
            if (read(p1[0], &prime, sizeof(prime)) <= 0) {
                break;  
            }
            printf("prime %d\n",prime);
            pipe(p2);
            if(fork()>0){
                while(read(p1[0],&n,sizeof(n))>0){
                    if(n%prime!=0){
                        write(p2[1],&n,sizeof(n));
                    }
                }
                //关闭不需要的端口
                close(p1[0]);
                close(p2[1]);
                //等待
                int status;
                wait(&status);
                break;
            }
            else{
                //交换数据，将子进程作为下一次的父进程
                close(p1[0]);
                p1[0]=p2[0];
                p1[1]=p2[1];
            }
        }
    }
    exit(0);
}