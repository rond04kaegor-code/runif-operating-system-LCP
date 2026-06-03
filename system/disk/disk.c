#include "disk.h"
#include "../drivers/tty.h"
static DiskDevice d[8];static int dc=0;
static unsigned char inb(unsigned short p){unsigned char r;__asm__ volatile("inb %1,%0":"=a"(r):"Nd"(p));return r;}
static void outb(unsigned short p,unsigned char v){__asm__ volatile("outb %0,%1"::"a"(v),"Nd"(p));}
static unsigned short inw(unsigned short p){unsigned short r;__asm__ volatile("inw %1,%0":"=a"(r):"Nd"(p));return r;}
static void outw(unsigned short p,unsigned short v){__asm__ volatile("outw %0,%1"::"a"(v),"Nd"(p));}
static int ata_identify(unsigned short port){outb(port+6,0xA0);outb(port+2,0);outb(port+3,0);outb(port+4,0);outb(port+5,0);outb(port+7,0xEC);unsigned char s=inb(port+7);if(s==0||s==0xFF)return 0;while(inb(port+7)&0x80);if(!(inb(port+7)&0x08))return 0;for(int i=0;i<256;i++)inw(port);return 1;}
int disk_detect_fs(int n){if(n>=dc||!d[n].present)return 0;unsigned char boot[512];if(!disk_read_sector(n,0,boot))return 0;
if(boot[0x52]=='F'&&boot[0x53]=='A'&&boot[0x54]=='T'&&boot[0x55]=='3'&&boot[0x56]=='2'){d[n].filesystem=1;d[n].fs_name[0]='F';d[n].fs_name[1]='A';d[n].fs_name[2]='T';d[n].fs_name[3]='3';d[n].fs_name[4]='2';d[n].fs_name[5]=0;return 1;}
if(boot[3]=='N'&&boot[4]=='T'&&boot[5]=='F'&&boot[6]=='S'){d[n].filesystem=2;d[n].fs_name[0]='N';d[n].fs_name[1]='T';d[n].fs_name[2]='F';d[n].fs_name[3]='S';d[n].fs_name[4]=0;return 2;}
d[n].filesystem=0;d[n].fs_name[0]='N';d[n].fs_name[1]='o';d[n].fs_name[2]='n';d[n].fs_name[3]='e';d[n].fs_name[4]=0;return 0;}
void disk_init(void){dc=0;for(int i=0;i<8;i++){d[i].present=0;d[i].filesystem=0;d[i].fs_name[0]='N';d[i].fs_name[1]='o';d[i].fs_name[2]='n';d[i].fs_name[3]='e';d[i].fs_name[4]=0;}}
int disk_scan(void){dc=0;
if(ata_identify(ATA_PRIMARY)&&dc<8){DiskDevice* p=&d[dc];p->present=1;p->sectors=0x200000;p->sector_size=512;char* n="ATA Disk 0";int j;for(j=0;n[j]&&j<63;j++)p->name[j]=n[j];p->name[j]=0;disk_detect_fs(dc);p->fs_size_mb=(p->sectors*p->sector_size)/(1024*1024);dc++;}
if(dc==0){DiskDevice* p=&d[dc];p->present=1;p->sectors=2880;p->sector_size=512;char* n="Virtual Disk";int j;for(j=0;n[j]&&j<63;j++)p->name[j]=n[j];p->name[j]=0;disk_detect_fs(dc);p->fs_size_mb=1;dc++;}
return dc;}
int disk_format_fat32(int n){if(n>=dc||!d[n].present)return 0;unsigned char boot[512];for(int i=0;i<512;i++)boot[i]=0;boot[0]=0xEB;boot[1]=0x58;boot[2]=0x90;boot[82]='F';boot[83]='A';boot[84]='T';boot[85]='3';boot[86]='2';boot[510]=0x55;boot[511]=0xAA;disk_write_sector(n,0,boot);d[n].filesystem=1;d[n].fs_name[0]='F';d[n].fs_name[1]='A';d[n].fs_name[2]='T';d[n].fs_name[3]='3';d[n].fs_name[4]='2';d[n].fs_name[5]=0;return 1;}
int disk_write_sector(int disk,unsigned int lba,unsigned char* buf){if(disk>=dc||!d[disk].present)return 0;outb(ATA_PRIMARY+6,0xE0|((lba>>24)&0x0F));outb(ATA_PRIMARY+2,1);outb(ATA_PRIMARY+3,lba&0xFF);outb(ATA_PRIMARY+4,(lba>>8)&0xFF);outb(ATA_PRIMARY+5,(lba>>16)&0xFF);outb(ATA_PRIMARY+7,0x30);while(inb(ATA_PRIMARY+7)&0x80);for(int i=0;i<256;i++){unsigned short w=buf[i*2]|(buf[i*2+1]<<8);outw(ATA_PRIMARY,w);}return 1;}
int disk_read_sector(int disk,unsigned int lba,unsigned char* buf){if(disk>=dc||!d[disk].present)return 0;outb(ATA_PRIMARY+6,0xE0|((lba>>24)&0x0F));outb(ATA_PRIMARY+2,1);outb(ATA_PRIMARY+3,lba&0xFF);outb(ATA_PRIMARY+4,(lba>>8)&0xFF);outb(ATA_PRIMARY+5,(lba>>16)&0xFF);outb(ATA_PRIMARY+7,0x20);while(inb(ATA_PRIMARY+7)&0x80);for(int i=0;i<256;i++){unsigned short w=inw(ATA_PRIMARY);buf[i*2]=w&0xFF;buf[i*2+1]=(w>>8)&0xFF;}return 1;}
void disk_info(int n){if(n>=dc||!d[n].present)return;tty_puts("📀 ");tty_puts(d[n].name);tty_puts("\n   Size: ");char sz[8];int val=d[n].fs_size_mb,p=0;if(val==0)sz[p++]='0';else{char t[8];int tp=0;while(val){t[tp++]='0'+(val%10);val/=10;}while(tp)sz[p++]=t[--tp];}sz[p]=0;tty_puts(sz);tty_puts(" MB\n   FS: ");tty_puts(d[n].fs_name);tty_puts("\n\n");}
int disk_cnt(void){return dc;}
DiskDevice* disk_get(int n){return(n<dc)?&d[n]:0;}
