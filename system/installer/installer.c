#include "installer.h"
#include "../drivers/tty.h"
#include "../drivers/keyboard.h"
#include "../fs/fs.h"
void rinst_install(const char* fn){tty_puts("RINST Installer\n");char* d=fs_get_data(fn);if(!d)return;if(d[0]!='R'||d[1]!='I'||d[2]!='N'||d[3]!='S'||d[4]!='T')return;int nf=d[5];int off=6;for(int i=0;i<nf;i++){char fn2[32];int j;for(j=0;d[off+j]&&j<31;j++)fn2[j]=d[off+j];fn2[j]=0;off+=32;int fs2=d[off]|(d[off+1]<<8);off+=2;char fd[4096];for(j=0;j<fs2&&j<4095;j++)fd[j]=d[off+j];fd[j]=0;off+=fs2;fs_create(fn2,fd);}char prg[64];int i;for(i=0;fn[i]&&fn[i]!='.'&&i<60;i++)prg[i]=fn[i];prg[i]='.';prg[i+1]='p';prg[i+2]='r';prg[i+3]='g';prg[i+4]=0;fs_create(prg,"");tty_puts("OK\n");}
void installer_run(void){tty_puts("File: ");char fn[64];kb_line(fn,64);rinst_install(fn);}
