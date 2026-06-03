#include "../drivers/tty.h"
#include "../drivers/keyboard.h"
void diskoteka_main(void){tty_puts("═══ DISKOTEKA ═══\n🎵 Press ESC to exit\n");int f=0;while(1){kb_handler();if(kb_esc_pressed())break;tty_setpos(10+f,10);tty_puts("🎵♪♫");tty_setpos(50-f,15);tty_puts("♫♪🎵");for(volatile int i=0;i<300000;i++);tty_clear();f=(f+1)%30;}tty_puts("Disco ended!\n");}
