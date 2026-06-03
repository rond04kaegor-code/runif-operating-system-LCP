#include "config.h"
#include "../drivers/tty.h"
#include "../drivers/keyboard.h"
#include "../fs/fs.h"
int config_exists(void){return fs_exists("/runif-os/os.conf");}
void config_run(void){tty_clear();tty_fill(0,0,80,1,' ',0x1F);tty_setpos(20,0);tty_setcolor(0x1F);tty_puts(" CONFIGURATOR ");tty_setcolor(0x07);tty_setpos(0,2);tty_puts("\n  [1] Set hostname\n  [2] Save\n  Choice: ");char c=kb_get();tty_putc(c);tty_putc('\n');char d[512];d[0]=0;if(c=='1'){tty_puts("  Hostname: ");char h[64];kb_line(h,64);d[0]='h';d[1]='o';d[2]='s';d[3]='t';d[4]='=';for(int i=0;h[i];i++)d[5+i]=h[i];d[5+slen(h)]='\n';}else{d[0]='h';d[1]='o';d[2]='s';d[3]='t';d[4]='=';d[5]='r';d[6]='u';d[7]='n';d[8]='i';d[9]='f';d[10]='\n';}fs_create("/runif-os/os.conf",d);tty_puts("\n  Saved!\n");kb_get();}
