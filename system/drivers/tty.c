#include "tty.h"
static unsigned short* vga=(unsigned short*)0xB8000;static int cx=0,cy=0;static unsigned char cl=0x07;
void tty_init(void){cx=cy=0;for(int y=0;y<25;y++)for(int x=0;x<80;x++)vga[y*80+x]=0x0720;}
void tty_setcolor(unsigned char c){cl=c;}
void tty_scroll(void){for(int y=1;y<25;y++)for(int x=0;x<80;x++)vga[(y-1)*80+x]=vga[y*80+x];for(int x=0;x<80;x++)vga[24*80+x]=(cl<<8)|' ';cy=24;}
void tty_putc(char c){if(c=='\n'){cx=0;if(++cy==25)tty_scroll();return;}if(c=='\r'){cx=0;return;}if(c=='\b'){if(cx>0){cx--;vga[cy*80+cx]=(cl<<8)|' ';}return;}vga[cy*80+cx]=(cl<<8)|c;if(++cx==80){cx=0;if(++cy==25)tty_scroll();}}
void tty_puts(const char* s){while(*s)tty_putc(*s++);}
void tty_clear(void){cx=cy=0;for(int y=0;y<25;y++)for(int x=0;x<80;x++)vga[y*80+x]=(cl<<8)|' ';}
void tty_setpos(int x,int y){cx=x;cy=y;}
void tty_drawbox(int x,int y,int w,int h,unsigned char c){for(int i=0;i<w;i++){vga[y*80+x+i]=(c<<8)|' ';vga[(y+h-1)*80+x+i]=(c<<8)|' ';}for(int i=0;i<h;i++){vga[(y+i)*80+x]=(c<<8)|' ';vga[(y+i)*80+x+w-1]=(c<<8)|' ';}}
void tty_fill(int x,int y,int w,int h,char ch,unsigned char c){for(int j=0;j<h;j++)for(int i=0;i<w;i++)vga[(y+j)*80+x+i]=(c<<8)|ch;}
int scmp(const char* a,const char* b){while(*a&&*a==*b){a++;b++;}return*(unsigned char*)a-*(unsigned char*)b;}
int slen(const char* s){int l=0;while(*s++)l++;return l;}
