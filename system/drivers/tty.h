#ifndef TTY_H
#define TTY_H
void tty_init(void);void tty_putc(char c);void tty_puts(const char* s);void tty_clear(void);
void tty_setcolor(unsigned char c);void tty_scroll(void);void tty_setpos(int x,int y);
void tty_drawbox(int x,int y,int w,int h,unsigned char c);void tty_fill(int x,int y,int w,int h,char ch,unsigned char c);
int scmp(const char* a,const char* b);int slen(const char* s);
#endif
