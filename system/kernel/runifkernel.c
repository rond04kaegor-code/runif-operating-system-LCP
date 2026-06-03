#include "../drivers/tty.h"
#include "../drivers/keyboard.h"
#include "../rsdbash/rsdbash.h"
#include "../fs/fs.h"
#include "../rmp/rmp.h"
#include "../disk/disk.h"
#include "../config/config.h"
extern char user[32];
void runifkernel_main(unsigned int magic,unsigned int addr){
    tty_init();kb_init();disk_init();fs_init();rmp_init();int n=disk_scan();
    if(!fs_exists("/runif-os/os.conf")){config_run();}
    if(!fs_exists("/runif-os/name-user.txt")){
        tty_fill(0,0,80,1,' ',0x1F);tty_setpos(20,0);tty_setcolor(0x1F);tty_puts(" RUNIF OS 1.0 ");tty_setcolor(0x07);tty_setpos(0,2);
        tty_puts("\n  Username: ");char name[32];kb_line(name,32);
        if(scmp(name,"root")==0){tty_puts("  Reserved!\n  Username: ");kb_line(name,32);}
        fs_create("/runif-os/name-user.txt",name);
        int i;for(i=0;name[i]&&i<31;i++){user[i]=name[i];}user[i]=0;
    }else{
        char* data=fs_get_data("/runif-os/name-user.txt");
        if(data){int i;for(i=0;data[i]&&data[i]!='\n'&&i<31;i++){user[i]=data[i];}user[i]=0;}
        tty_fill(0,0,80,1,' ',0x1F);tty_setpos(25,0);tty_setcolor(0x1F);tty_puts(" RUNIF OS 1.0 ");tty_setcolor(0x07);tty_setpos(0,2);
        tty_puts("\n  Welcome back, ");tty_puts(user);tty_puts("!\n\n");
    }
    tty_setcolor(0x0B);tty_puts("  Disks: ");char sz[4];sz[0]='0'+n;sz[1]=0;tty_puts(sz);tty_puts("\n\n");tty_setcolor(0x07);
    tty_puts("Type 'help' for commands. Type program name to run.\n\n");rsdbash_run();while(1){kb_handler();}
}
