#include "rmp.h"
#include "../drivers/tty.h"
#include "../kernel/commands.h"
static struct{char n[64];int ok;}p[128];static int pc=0;
void rmp_init(void){pc=0;}
void rmp_do(int c,char** v){if(c<2){tty_puts("RMP: notenano cat rcat filem calculator snake diskoteka guess-the-number\nin-start-kernel sysinfo taskmgr diskspace meminfo edit ps\nlython-lg (super-user prg install lython-lg.rinst)\n");return;}if(scmp(v[1],"install")==0&&c>=3)rmp_inst(v[2]);else if(scmp(v[1],"list")==0)rmp_list();}
void rmp_inst(const char* n){if(pc<128){int i=pc++,j;for(j=0;n[j]&&j<63;j++)p[i].n[j]=n[j];p[i].n[j]=0;p[i].ok=1;tty_puts("OK\n");}}
void rmp_list(void){int f=0;for(int i=0;i<pc;i++)if(p[i].ok){tty_puts(p[i].n);tty_puts("\n");f=1;}if(!f)tty_puts("none\n");}
