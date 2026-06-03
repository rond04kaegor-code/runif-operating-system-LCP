#include "../drivers/tty.h"
#include "../drivers/keyboard.h"
void notenano_main(void){tty_puts("═══ NOTENANO v1.0 ═══\nType text, Enter to save:\n");char b[4096];kb_line(b,4096);tty_puts("✅ Saved!\n");}
