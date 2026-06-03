#include "rsdbash.h"
#include "../drivers/tty.h"
#include "../drivers/keyboard.h"
#include "../fs/fs.h"
#include "../kernel/commands.h"
extern char user[32];extern int uid;
void rsdbash_run(void){char cmd[512],*args[32];while(1){tty_setcolor(uid?0x0C:0x0A);tty_puts(user);tty_puts(uid?"@runif:~# ":"@runif:~$ ");tty_setcolor(0x07);kb_line(cmd,512);fs_log(cmd);char buf[512];int i;for(i=0;cmd[i]&&i<511;i++)buf[i]=cmd[i];buf[i]=0;int argc=0;char* t=buf;while(*t==' ')t++;while(*t&&argc<31){args[argc++]=t;while(*t&&*t!=' ')t++;if(*t){*t=0;t++;}while(*t==' ')t++;}args[argc]=0;if(argc>0)exec_cmd(argc,args);}}
