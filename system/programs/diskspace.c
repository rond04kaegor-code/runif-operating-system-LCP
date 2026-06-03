#include "../drivers/tty.h"
#include "../disk/disk.h"
void diskspace_main(void){tty_puts("═══ DISK SPACE ═══\n");for(int i=0;i<disk_cnt();i++){DiskDevice* d=disk_get(i);if(d&&d->present){tty_puts("📀 ");tty_puts(d->name);tty_puts("\n   FS: ");tty_puts(d->fs_name);tty_puts("\n   Size: ");char sz[8];int val=d->fs_size_mb,p=0;if(val==0)sz[p++]='0';else{char t[8];int tp=0;while(val){t[tp++]='0'+(val%10);val/=10;}while(tp)sz[p++]=t[--tp];}sz[p]=0;tty_puts(sz);tty_puts(" MB\n\n");}}}
