#include "keyboard.h"
#include "tty.h"
static char buf[512];static int bp=0,bl=0,sh=0,esc=0;
static const char km[128]={0,27,'1','2','3','4','5','6','7','8','9','0','-','=','\b','\t','q','w','e','r','t','y','u','i','o','p','[',']','\n',0,'a','s','d','f','g','h','j','k','l',';','\'','`',0,'\\','z','x','c','v','b','n','m',',','.','/',0,'*',0,' '};
static unsigned char inb(unsigned short p){unsigned char r;__asm__ volatile("inb %1,%0":"=a"(r):"Nd"(p));return r;}
void kb_init(void){bp=bl=sh=0;esc=0;}
void kb_handler(void){unsigned char s=inb(0x64);if(s&1){unsigned char k=inb(0x60);if(k&0x80){if(k==0xAA||k==0xB6)sh=0;}else{if(k==0x2A||k==0x36)sh=1;else if(k==1)esc=1;else if(k<128){char c=km[k];if(sh&&c>='a'&&c<='z')c-=32;if(c&&bl<512){buf[bp]=c;bp=(bp+1)%512;bl++;}}}}}
int kb_has(void){return bl>0;}
char kb_get(void){while(!kb_has()){kb_handler();}int p=(bp-bl+512)%512;bl--;return buf[p];}
void kb_line(char* b,int m){int i=0;while(i<m-1){char c=kb_get();if(c=='\n'){b[i]=0;tty_putc('\n');return;}if(c=='\b'){if(i>0){i--;tty_putc('\b');}}else if(c>=' '){b[i++]=c;tty_putc(c);}}b[i]=0;tty_putc('\n');}
int kb_getint(void){char b[16];kb_line(b,16);int n=0;for(int i=0;b[i];i++)if(b[i]>='0'&&b[i]<='9')n=n*10+(b[i]-'0');return n;}
int kb_esc_pressed(void){if(esc){esc=0;return 1;}return 0;}
