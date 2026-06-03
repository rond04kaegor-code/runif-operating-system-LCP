#ifndef FS_H
#define FS_H
void fs_init(void);void fs_create(const char* n,const char* c);void fs_list(void);
void fs_cat(const char* n);void fs_del(const char* n);
void fs_save(int disk);void fs_load(int disk);void fs_log(const char* cmd);
void fs_mkdir(const char* name);void fs_list_all(void);
int fs_exists(const char* n);char* fs_get_data(const char* n);
void fs_cd(const char* path);void fs_destroy_system(void);
#endif
