#include "../drivers/tty.h"
#include "../drivers/keyboard.h"
void guess_the_number_main(void){tty_puts("═══ GUESS THE NUMBER ═══\nI picked 0-100. Guess!\n");int s=42,g,t=0;do{tty_puts("Guess: ");g=kb_getint();t++;if(g<s)tty_puts("📈 Too low!\n");else if(g>s)tty_puts("📉 Too high!\n");}while(g!=s);tty_puts("🎉 Correct! Tries: ");char sz[8];int n=t,p=0;if(n==0)sz[p++]='0';else{char t2[8];int tp=0;while(n){t2[tp++]='0'+(n%10);n/=10;}while(tp)sz[p++]=t2[--tp];}sz[p]=0;tty_puts(sz);tty_puts("\n");}
