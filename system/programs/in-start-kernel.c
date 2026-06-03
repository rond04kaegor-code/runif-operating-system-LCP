#include "../drivers/tty.h"
#include "../drivers/keyboard.h"
void in_start_kernel_main(void){tty_puts("═══ KERNEL EMULATOR ═══\nType 'exit' to leave\n\n");char cmd[512];while(1){tty_setcolor(0x0E);tty_puts("kernel:~# ");tty_setcolor(0x07);kb_line(cmd,512);int ex=1;char* e="exit";for(int i=0;i<4;i++)if(cmd[i]!=e[i])ex=0;if(ex&&(cmd[4]==0||cmd[4]==' ')){tty_puts("Exiting emulation.\n");break;}if(cmd[0]){tty_puts("kernel: ");tty_puts(cmd);tty_puts(": not found\n");}}}
