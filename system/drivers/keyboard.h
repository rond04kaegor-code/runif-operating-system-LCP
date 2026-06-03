#ifndef KB_H
#define KB_H
void kb_init(void);void kb_handler(void);int kb_has(void);char kb_get(void);void kb_line(char* b,int m);int kb_getint(void);int kb_esc_pressed(void);
#endif
