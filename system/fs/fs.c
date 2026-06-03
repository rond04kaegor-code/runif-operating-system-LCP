#include "fs.h"
#include "../drivers/tty.h"
#include "../drivers/keyboard.h"
#include "../disk/disk.h"
typedef struct{char n[64];char d[8192];int s;int is_dir;int locked;}File;
static File f[256];static int fc=0;static char cur[64]="/";
static void copy_str(char* d,const char* s){while(*s){*d=*s;d++;s++;}*d=0;}
static void copy_buf(char* d,const char* s,int n){for(int i=0;i<n;i++)d[i]=s[i];}
void fs_init(void){fc=0;fs_create("/runif-os/README.TXT","RUNIF OS 1.0\n");fs_create("/runif-os/WELCOME.TXT","Welcome!\n");fs_create("/runif-os/SYSTEM.INI","[System]\nversion=1.0\n");fs_create("/logs/log.txt","--- LOG ---\n\n");}
void fs_create(const char* n,const char* c){if(fc>=256)return;File* ff=&f[fc++];int i;for(i=0;n[i]&&i<63;i++){ff->n[i]=n[i];}ff->n[i]=0;for(i=0;c[i]&&i<8191;i++){ff->d[i]=c[i];}ff->d[i]=0;ff->s=i;ff->is_dir=(n[slen(n)-1]=='/')?1:0;ff->locked=0;}
void fs_mkdir(const char* name){char full[64];full[0]='/';int i;for(i=0;name[i]&&i<62;i++)full[i+1]=name[i];full[i+1]='/';full[i+2]=0;fs_create(full,"");}
void fs_cd(const char* path){if(scmp(path,"..")==0){cur[0]='/';cur[1]=0;return;}if(path[0]=='/'){for(int i=0;path[i]&&i<63;i++)cur[i]=path[i];cur[63]=0;}else{int len=slen(cur);for(int i=0;path[i]&&len+i<63;i++)cur[len+i]=path[i];cur[len+slen(path)]=0;}tty_puts("Path: ");tty_puts(cur);tty_puts("\n");}
void fs_list(void){for(int i=0;i<fc;i++){if(f[i].is_dir)tty_puts("📁 ");else tty_puts("📄 ");tty_puts(f[i].n);if(f[i].locked)tty_puts(" 🔒");tty_puts("\n");}}
void fs_list_all(void){fs_list();}
void fs_cat(const char* n){for(int i=0;i<fc;i++){if(scmp(f[i].n,n)==0){tty_puts(f[i].d);return;}}tty_puts("Not found\n");}
void fs_del(const char* n){for(int i=0;i<fc;i++){if(scmp(f[i].n,n)==0){if(f[i].locked){tty_puts("🔒 Locked!\n");return;}for(int j=i;j<fc-1;j++){copy_str(f[j].n,f[j+1].n);copy_buf(f[j].d,f[j+1].d,f[j+1].s+1);f[j].s=f[j+1].s;f[j].is_dir=f[j+1].is_dir;f[j].locked=f[j+1].locked;}fc--;return;}}}
int fs_exists(const char* n){for(int i=0;i<fc;i++)if(scmp(f[i].n,n)==0)return 1;return 0;}
char* fs_get_data(const char* n){for(int i=0;i<fc;i++)if(scmp(f[i].n,n)==0)return f[i].d;return 0;}
void fs_log(const char* cmd){for(int i=0;i<fc;i++){if(scmp(f[i].n,"/logs/log.txt")==0){int len=f[i].s;f[i].d[len++]='>';f[i].d[len++]=' ';for(int j=0;cmd[j]&&len<8190;j++)f[i].d[len++]=cmd[j];f[i].d[len++]='\n';f[i].d[len]=0;f[i].s=len;return;}}}
void fs_save(int disk){tty_puts("Saving...\n");unsigned char sec[512];for(int i=0;i<512;i++)sec[i]=0;sec[0]='R';sec[1]='U';sec[2]='N';sec[3]='I';sec[4]=fc&0xFF;sec[5]=(fc>>8)&0xFF;disk_write_sector(disk,1,sec);for(int i=0;i<fc;i++){for(int j=0;j<512;j++)sec[j]=0;copy_buf(sec,f[i].n,32);sec[32]=f[i].s&0xFF;sec[33]=(f[i].s>>8)&0xFF;sec[34]=f[i].is_dir;sec[35]=f[i].locked;disk_write_sector(disk,2+i*2,sec);for(int j=0;j<512;j++)sec[j]=0;copy_buf(sec,f[i].d,f[i].s<512?f[i].s:512);disk_write_sector(disk,3+i*2,sec);}tty_puts("Saved!\n");}
void fs_load(int disk){tty_puts("Loading...\n");unsigned char sec[512];disk_read_sector(disk,1,sec);if(sec[0]!='R'||sec[1]!='U'||sec[2]!='N'||sec[3]!='I'){tty_puts("No FS!\n");return;}fc=sec[4]|(sec[5]<<8);if(fc>256)fc=0;for(int i=0;i<fc;i++){disk_read_sector(disk,2+i*2,sec);copy_buf(f[i].n,(char*)sec,32);f[i].n[31]=0;f[i].s=sec[32]|(sec[33]<<8);f[i].is_dir=sec[34];f[i].locked=sec[35];disk_read_sector(disk,3+i*2,sec);copy_buf(f[i].d,(char*)sec,f[i].s<512?f[i].s:512);f[i].d[f[i].s]=0;}tty_puts("Loaded!\n");}
void fs_destroy_system(void){unsigned char z[512];for(int i=0;i<512;i++)z[i]=0;for(int i=0;i<fc;i++){for(int j=0;f[i].n[j];j++)f[i].n[j]=0;for(int j=0;j<8192;j++)f[i].d[j]=0;}fc=0;disk_write_sector(0,0,z);for(int i=2;i<100;i++)disk_write_sector(0,i,z);z[0]='R';z[1]='I';z[2]='P';z[3]='!';disk_write_sector(0,0,z);tty_puts("💀 Destroyed.\n");}
