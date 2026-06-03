#include "../drivers/tty.h"
#include "../drivers/keyboard.h"
#include "../disk/disk.h"
void filem_main(void){tty_clear();tty_fill(0,0,80,1,' ',0x1F);tty_setpos(25,0);tty_setcolor(0x1F);tty_puts(" FILE MANAGER ");tty_setcolor(0x07);tty_setpos(0,2);unsigned char s[512];disk_read_sector(0,1,s);if(s[0]=='R'&&s[1]=='U'&&s[2]=='N'&&s[3]=='I'){int n=s[4]|(s[5]<<8);for(int i=0;i<n&&i<20;i++){disk_read_sector(0,2+i*2,s);tty_puts("  📄 ");for(int j=0;j<31&&s[j];j++)tty_putc(s[j]);tty_puts("\n");}}else{tty_puts("No filesystem found.\nUse 'format 1' then 'save'.\n");}tty_puts("\n[Press any key to exit]\n");kb_get();}
