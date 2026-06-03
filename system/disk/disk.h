#ifndef DISK_H
#define DISK_H
#define ATA_PRIMARY 0x1F0
typedef struct{char name[64];unsigned int sectors;unsigned int sector_size;int present;int filesystem;char fs_name[16];unsigned int fs_size_mb;}DiskDevice;
void disk_init(void);int disk_scan(void);int disk_detect_fs(int n);int disk_format_fat32(int n);
int disk_write_sector(int disk,unsigned int lba,unsigned char* buf);
int disk_read_sector(int disk,unsigned int lba,unsigned char* buf);
void disk_info(int n);int disk_cnt(void);DiskDevice* disk_get(int n);
#endif
