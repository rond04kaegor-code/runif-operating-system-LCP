#include "commands.h"
#include "../drivers/tty.h"
#include "../drivers/keyboard.h"
#include "../fs/fs.h"
#include "../rmp/rmp.h"
#include "../disk/disk.h"
#include "../config/config.h"
#include "../installer/installer.h"
int uid=0;char user[32]="user";

// PRG function pointers
extern void notenano_main(void);
extern void cat_main(void);
extern void rcat_main(void);
extern void filem_main(void);
extern void calculator_main(void);
extern void guess_the_number_main(void);
extern void snake_main(void);
extern void diskoteka_main(void);
extern void in_start_kernel_main(void);
extern void sysinfo_main(void);
extern void taskmgr_main(void);
extern void diskspace_main(void);
extern void meminfo_main(void);
extern void edit_main(void);
extern void ps_main(void);

void exec_cmd(int c,char** v){
    if(!c)return;
    // PRG LAUNCHER - check program names
    if(scmp(v[0],"notenano")==0){notenano_main();return;}
    if(scmp(v[0],"cat")==0){cat_main();return;}
    if(scmp(v[0],"rcat")==0){rcat_main();return;}
    if(scmp(v[0],"filem")==0){filem_main();return;}
    if(scmp(v[0],"calculator")==0){calculator_main();return;}
    if(scmp(v[0],"guess-the-number")==0){guess_the_number_main();return;}
    if(scmp(v[0],"snake")==0){snake_main();return;}
    if(scmp(v[0],"diskoteka")==0){diskoteka_main();return;}
    if(scmp(v[0],"in-start-kernel")==0){in_start_kernel_main();return;}
    if(scmp(v[0],"sysinfo")==0){sysinfo_main();return;}
    if(scmp(v[0],"taskmgr")==0){taskmgr_main();return;}
    if(scmp(v[0],"diskspace")==0){diskspace_main();return;}
    if(scmp(v[0],"meminfo")==0){meminfo_main();return;}
    if(scmp(v[0],"edit")==0){edit_main();return;}
    if(scmp(v[0],"ps")==0){ps_main();return;}
    
    // System commands
    if(scmp(v[0],"help")==0){tty_puts("═══ RUNIF OS 1.0 ═══\nnotenano cat rcat filem calculator\nguess-the-number snake diskoteka in-start-kernel\nsysinfo taskmgr diskspace meminfo edit ps\nhelp clear version whoami super-user exit\nls cat create rm mkdir cd rmp filem disks\nformat save load reboot shutdown config\nrm -log (destroy system)\n");}
    else if(scmp(v[0],"clear")==0)tty_clear();
    else if(scmp(v[0],"whoami")==0){tty_puts(user);tty_puts(uid?" (root)\n":"\n");}
    else if(scmp(v[0],"version")==0)tty_puts("RUNIF OS 1.0 - 15 programs\n");
    else if(scmp(v[0],"config")==0)config_run();
    else if(scmp(v[0],"cd")==0&&c>=2)fs_cd(v[1]);
    else if(scmp(v[0],"super-user")==0){if(c>=2&&scmp(v[1],"--root-group")==0){uid=1;tty_puts("Root.\n");}else if(c>=4&&scmp(v[1],"prg")==0&&scmp(v[2],"install")==0){rinst_install(v[3]);}else if(c>=2&&scmp(v[1],"rm")==0&&scmp(v[2],"-log")==0){fs_destroy_system();for(volatile int i=0;i<10000000;i++);__asm__ volatile("cli;hlt");}}
    else if(scmp(v[0],"rm")==0&&c>=2&&scmp(v[1],"-log")==0){if(uid==1){fs_destroy_system();for(volatile int i=0;i<10000000;i++);__asm__ volatile("cli;hlt");}else tty_puts("Need root.\n");}
    else if(scmp(v[0],"exit")==0&&c>=2&&scmp(v[1],"--root")==0){if(uid==1){uid=0;tty_puts("User.\n");}}
    else if(scmp(v[0],"ls")==0)fs_list();
    else if(scmp(v[0],"catf")==0&&c>=2)fs_cat(v[1]);
    else if(scmp(v[0],"create")==0&&c>=2){fs_create(v[1],"");tty_puts("OK\n");}
    else if(scmp(v[0],"mkdir")==0&&c>=2){fs_mkdir(v[1]);tty_puts("OK\n");}
    else if(scmp(v[0],"rmf")==0&&c>=2){fs_del(v[1]);}
    else if(scmp(v[0],"rmp")==0)rmp_do(c,v);
    else if(scmp(v[0],"disks")==0){for(int i=0;i<disk_cnt();i++)disk_info(i);}
    else if(scmp(v[0],"format")==0&&c>=2){if(disk_format_fat32(v[1][0]-'1'))tty_puts("FAT32 formatted!\n");}
    else if(scmp(v[0],"save")==0)fs_save(0);
    else if(scmp(v[0],"load")==0)fs_load(0);
    else if(scmp(v[0],"reboot")==0){for(volatile int i=0;i<1000000;i++);__asm__ volatile("int $0x19");}
    else if(scmp(v[0],"shutdown")==0){for(volatile int i=0;i<1000000;i++);__asm__ volatile("cli;hlt");}
    else{tty_puts("?: ");tty_puts(v[0]);tty_puts("\nType 'help' for commands.\n");}
}
