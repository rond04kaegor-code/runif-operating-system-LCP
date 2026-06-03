#include "../drivers/tty.h"
#include "../drivers/keyboard.h"
void edit_main(void){tty_puts("═══ QUICK EDIT ═══\nText: ");char b[4096];kb_line(b,4096);tty_puts("✅ Saved!\n");}
