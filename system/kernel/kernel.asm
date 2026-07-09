[ORG 0x0000]
[BITS 16]

jmp kernel_start

; ============ DATA ============
username     db 'runif',0
hostname     db 'runif-os',0
shell_prompt db ':~$ ',0
csr_x db 0
csr_y db 0
screen_color db 0x07
kb_head dw 0
kb_tail dw 0
kb_buf times 256 db 0
input_buf times 256 db 0
arg_buf times 256 db 0

; RTC Moscow time
boot_hour db 0
boot_min  db 0
boot_sec  db 0
boot_day  db 0
boot_month db 0
boot_year db 0
boot_century db 0

; Process management
init_pid db 1
shell_pid db 2
current_pid db 2

; FAT12
fat1 times 4608 db 0
fat2 times 4608 db 0
root_dir times 7168 db 0
data_region times 8192 db 0
next_free dw 3
temp times 512 db 0
pbuf times 64 db 0

; Snake
snk_x db 40
snk_y db 12
snk_dx db 1
snk_dy db 0
snk_fx db 20
snk_fy db 10
snk_sc db 0

; Pong
pong_bx db 40
pong_by db 12
pong_bdx db 1
pong_bdy db 1
pong_p1y db 10
pong_p2y db 10
pong_s1 db 0
pong_s2 db 0

; Calculator
cn1 dw 0
cn2 dw 0
cop db 0
cres dw 0

; Help
hpage dw 0

; Kernel panic counter
panic_line dw 0

setup_name db 'SETUP   BIN',0
user_cfg db 'USER    CFG',0
prompt_cfg db 'PROMPT  CFG',0
boot_logo db 'LOADLOGO PNG',0
view_test db 'RUNIF   PNG',0
def_user db 'runif',0

; ============ KERNEL PANIC (ENGLISH) ============
kernel_panic:
    mov byte [screen_color], 0x4F
    call screen_clear
    
    mov dh, 0
    mov dl, 0
    mov si, panic_header
    call print_at
    
    mov dh, 2
    mov dl, 0
    mov si, panic_msg1
    call println
    call println
    
    pop si
    call println
    call println
    
    mov word [panic_line], 0
    
.panic_loop:
    mov ax, [panic_line]
    call print_dec
    mov si, panic_line_prefix
    call print
    
    mov ax, [panic_line]
    mov bx, 20
    xor dx, dx
    div bx
    
    cmp dx, 0
    jne .n0
    mov si, panic_detail_0
    jmp .print_panic
.n0:
    cmp dx, 1
    jne .n1
    mov si, panic_detail_1
    jmp .print_panic
.n1:
    cmp dx, 2
    jne .n2
    mov si, panic_detail_2
    jmp .print_panic
.n2:
    cmp dx, 3
    jne .n3
    mov si, panic_detail_3
    jmp .print_panic
.n3:
    cmp dx, 4
    jne .n4
    mov si, panic_detail_4
    jmp .print_panic
.n4:
    cmp dx, 5
    jne .n5
    mov si, panic_detail_5
    jmp .print_panic
.n5:
    cmp dx, 6
    jne .n6
    mov si, panic_detail_6
    jmp .print_panic
.n6:
    cmp dx, 7
    jne .n7
    mov si, panic_detail_7
    jmp .print_panic
.n7:
    cmp dx, 8
    jne .n8
    mov si, panic_detail_8
    jmp .print_panic
.n8:
    cmp dx, 9
    jne .n9
    mov si, panic_detail_9
    jmp .print_panic
.n9:
    cmp dx, 10
    jne .n10
    mov si, panic_detail_10
    jmp .print_panic
.n10:
    cmp dx, 11
    jne .n11
    mov si, panic_detail_11
    jmp .print_panic
.n11:
    cmp dx, 12
    jne .n12
    mov si, panic_detail_12
    jmp .print_panic
.n12:
    cmp dx, 13
    jne .n13
    mov si, panic_detail_13
    jmp .print_panic
.n13:
    cmp dx, 14
    jne .n14
    mov si, panic_detail_14
    jmp .print_panic
.n14:
    cmp dx, 15
    jne .n15
    mov si, panic_detail_15
    jmp .print_panic
.n15:
    cmp dx, 16
    jne .n16
    mov si, panic_detail_16
    jmp .print_panic
.n16:
    cmp dx, 17
    jne .n17
    mov si, panic_detail_17
    jmp .print_panic
.n17:
    cmp dx, 18
    jne .n18
    mov si, panic_detail_18
    jmp .print_panic
.n18:
    mov si, panic_detail_19
    jmp .print_panic

.print_panic:
    call println
    
    inc word [panic_line]
    
    mov ax, [panic_line]
    mov bx, 5
    xor dx, dx
    div bx
    cmp dx, 0
    jne .no_pause
    
    mov si, panic_pause
    call println
    call keyboard_getc
    
.no_pause:
    cmp word [panic_line], 1000000
    jb .panic_loop
    
    cli
    hlt
    jmp $

panic_header db '========================================',13,10
             db '  KERNEL PANIC - SYSTEM HALTED',13,10
             db '========================================',13,10,0

panic_msg1 db 'A critical error has occurred!',13,10
           db 'The system cannot continue.',13,10,0

panic_line_prefix db ': ',0

panic_pause db 13,10,'--- Press any key for more details ---',13,10,0

panic_detail_0  db 'The shell process (PID 2) was terminated.',13,10
                db 'This is the main user interface process.',13,10
                db 'Without it, the OS cannot function.',0
panic_detail_1  db 'What caused this?',13,10
                db 'A program may have crashed, or a critical',13,10
                db 'error occurred in the shell itself.',0
panic_detail_2  db 'The shell manages all user commands.',13,10
                db 'It provides: command parsing, program',13,10
                db 'execution, and system interaction.',0
panic_detail_3  db 'When the shell dies, no process remains',13,10
                db 'to handle user input or output.',13,10
                db 'The OS becomes completely unusable.',0
panic_detail_4  db 'Process hierarchy in RUNIF OS 2.0:',13,10
                db '  PID 1: init (system initialization)',13,10
                db '  PID 2: shell (user interface)',13,10
                db '  PID 3+: user programs',0
panic_detail_5  db 'If init (PID 1) were killed, the same',13,10
                db 'panic would occur. PID 1 is the root',13,10
                db 'of the entire process tree.',0
panic_detail_6  db 'The kernel detected that PID 2 is no',13,10
                db 'longer running. This is a fatal error',13,10
                db 'because no recovery is possible.',0
panic_detail_7  db 'Possible causes of shell termination:',13,10
                db '  1. Stack overflow in a user program',13,10
                db '  2. Invalid memory access (segfault)',13,10
                db '  3. Division by zero error',13,10
                db '  4. Manual kill command executed',0
panic_detail_8  db 'To prevent this from happening again:',13,10
                db '  - Do NOT kill PID 2 manually',13,10
                db '  - Report any bugs to the developer',13,10
                db '  - Restart the system when needed',0
panic_detail_9  db 'Current system state at panic time:',13,10
                db '  All processes have been stopped',13,10
                db '  Memory may be partially corrupted',13,10
                db '  Disk writes may be incomplete',0
panic_detail_10 db 'This panic screen shows extremely',13,10
                db 'detailed information about the crash.',13,10
                db 'It will continue for 1,000,000 lines.',0
panic_detail_11 db 'Why so many lines of explanation?',13,10
                db 'To ensure that even the most clueless',13,10
                db 'user understands exactly what happened',13,10
                db 'and knows they must restart the computer.',0
panic_detail_12 db 'The operating system is now in a',13,10
                db 'completely frozen state. No input is',13,10
                db 'processed. Only a hard reset can recover.',0
panic_detail_13 db 'Technical specifications:',13,10
                db '  Architecture: x86 Real Mode (16-bit)',13,10
                db '  Kernel type: Monolithic',13,10
                db '  File system: FAT12',13,10
                db '  Memory: Conventional only (640KB max)',0
panic_detail_14 db 'If you see this screen frequently:',13,10
                db '  - Check for buggy user programs',13,10
                db '  - Verify disk integrity',13,10
                db '  - Ensure no memory address conflicts',0
panic_detail_15 db 'The kernel cannot restart automatically',13,10
                db 'because Real Mode lacks memory protection',13,10
                db 'and process isolation. A full hardware',13,10
                db 'reset is absolutely required.',0
panic_detail_16 db 'To recover from this panic:',13,10
                db '  - Press the physical reset button',13,10
                db '  - Press Ctrl+Alt+Del (if enabled)',13,10
                db '  - Power cycle the machine',0
panic_detail_17 db 'Remember: the shell is your gateway',13,10
                db 'to the operating system. Without it,',13,10
                db 'you are left with a frozen screen',13,10
                db 'and an unusable computer.',0
panic_detail_18 db 'Killing PID 2 is like removing the',13,10
                db 'steering wheel from a moving car.',13,10
                db 'The engine (kernel) still runs, but',13,10
                db 'you cannot control where it goes.',0
panic_detail_19 db 'This concludes one cycle of panic',13,10
                db 'explanation. The message repeats',13,10
                db 'with different technical details',13,10
                db 'every 20 lines for 1,000,000 lines.',0

; ============ MOSCOW TIME (UTC+3) ============
cmos_read:
    out 0x70, al
    jmp $+2
    jmp $+2
    in al, 0x71
    ret

cmos_get_time:
    mov al, 0x04
    call cmos_read
    mov [boot_hour], al
    
    mov al, 0x02
    call cmos_read
    mov [boot_min], al
    
    mov al, 0x00
    call cmos_read
    mov [boot_sec], al
    
    mov al, 0x07
    call cmos_read
    mov [boot_day], al
    
    mov al, 0x08
    call cmos_read
    mov [boot_month], al
    
    mov al, 0x09
    call cmos_read
    mov [boot_year], al
    
    mov al, 0x32
    call cmos_read
    mov [boot_century], al
    
    ; Moscow time = UTC + 3
    mov al, [boot_hour]
    call bcd_to_bin
    add al, 3
    cmp al, 24
    jb .hour_ok
    sub al, 24
.hour_ok:
    call bin_to_bcd
    mov [boot_hour], al
    ret

bin_to_bcd:
    push bx
    xor ah, ah
    mov bl, 10
    div bl
    shl al, 4
    or al, ah
    pop bx
    ret

bcd_to_bin:
    push bx
    mov ah, al
    and al, 0x0F
    shr ah, 4
    mov bl, 10
    mul bl
    add al, ah
    pop bx
    ret

print_moscow_time:
    mov al, [boot_hour]
    call bcd_to_bin
    call print_dec
    mov al, ':'
    call putc
    
    mov al, [boot_min]
    call bcd_to_bin
    call print_dec
    mov al, ':'
    call putc
    
    mov al, [boot_sec]
    call bcd_to_bin
    call print_dec
    
    mov al, ' '
    call putc
    mov si, msk_str
    call print
    
    mov al, ' '
    call putc
    
    mov al, [boot_day]
    call bcd_to_bin
    call print_dec
    mov al, '/'
    call putc
    
    mov al, [boot_month]
    call bcd_to_bin
    call print_dec
    mov al, '/'
    call putc
    
    mov al, [boot_century]
    call bcd_to_bin
    call print_dec
    mov al, [boot_year]
    call bcd_to_bin
    call print_dec
    ret

msk_str db 'MSK',0

; ============ SCREEN ============
screen_init:
    mov ah,0x00
    mov al,0x03
    int 0x10
    ret

screen_clear:
    pusha
    mov ax,0x0600
    mov bh,[screen_color]
    xor cx,cx
    mov dx,0x184F
    int 0x10
    mov byte [csr_x],0
    mov byte [csr_y],0
    mov ah,0x02
    xor bh,bh
    xor dx,dx
    int 0x10
    popa
    ret

putc:
    pusha
    cmp al,13
    je .cr
    cmp al,10
    je .lf
    cmp al,8
    je .bs
    mov ah,0x09
    mov bh,0
    mov bl,[screen_color]
    mov cx,1
    int 0x10
    inc byte [csr_x]
    cmp byte [csr_x],80
    jb .sc
    mov byte [csr_x],0
    inc byte [csr_y]
    cmp byte [csr_y],25
    jb .sc
    call scroll
    jmp .d
.cr:
    mov byte [csr_x],0
    jmp .sc
.lf:
    inc byte [csr_y]
    cmp byte [csr_y],25
    jb .sc
    call scroll
    jmp .d
.bs:
    cmp byte [csr_x],0
    je .d
    dec byte [csr_x]
    mov ah,0x09
    mov al,' '
    mov bh,0
    mov bl,[screen_color]
    mov cx,1
    int 0x10
.sc:
    mov ah,0x02
    mov bh,0
    mov dh,[csr_y]
    mov dl,[csr_x]
    int 0x10
.d:
    popa
    ret

scroll:
    pusha
    mov ax,0x0601
    mov bh,[screen_color]
    xor cx,cx
    mov dx,0x184F
    int 0x10
    dec byte [csr_y]
    popa
    ret

print:
    lodsb
    or al,al
    jz .d
    call putc
    jmp print
.d:
    ret

print_at:
    mov byte [csr_x],dl
    mov byte [csr_y],dh
    mov ah,0x02
    mov bh,0
    int 0x10
    call print
    ret

println:
    call print
    mov al,13
    call putc
    mov al,10
    call putc
    ret

print_dec:
    pusha
    mov cx,0
    mov bx,10
.dd:
    xor dx,dx
    div bx
    push dx
    inc cx
    test ax,ax
    jnz .dd
.pp:
    pop ax
    add al,'0'
    call putc
    loop .pp
    popa
    ret

; ============ KEYBOARD ============
keyboard_init:
    mov word [kb_head],0
    mov word [kb_tail],0
    ret

keyboard_poll:
    pusha
    mov ah,0x01
    int 0x16
    jz .d
    mov ah,0x00
    int 0x16
    cmp al,0
    je .d
    mov bx,[kb_tail]
    mov [kb_buf+bx],al
    inc bx
    and bx,255
    mov [kb_tail],bx
.d:
    popa
    ret

keyboard_getc:
    push bx
.w:
    call keyboard_poll
    mov ax,[kb_head]
    cmp ax,[kb_tail]
    jne .h
    jmp .w
.h:
    mov bx,[kb_head]
    mov al,[kb_buf+bx]
    inc bx
    and bx,255
    mov [kb_head],bx
    pop bx
    ret

keyboard_has_key:
    call keyboard_poll
    mov ax,[kb_head]
    cmp ax,[kb_tail]
    je .n
    mov ax,1
    ret
.n:
    xor ax,ax
    ret

read_line:
    push bx
    push cx
    push di
    mov di,input_buf
    xor cx,cx
.l:
    call keyboard_getc
    cmp al,13
    je .d
    cmp al,8
    je .bs
    cmp al,27
    je .esc
    cmp al,' '
    jb .l
    cmp cx,254
    jae .l
    stosb
    inc cx
    call putc
    jmp .l
.bs:
    test cx,cx
    jz .l
    dec di
    dec cx
    mov al,8
    call putc
    jmp .l
.esc:
    xor cx,cx
    mov di,input_buf
    jmp .l
.d:
    mov byte [di],0
    mov al,13
    call putc
    mov al,10
    call putc
    pop di
    pop cx
    pop bx
    ret

; ============ STRING ============
strcmp:
    push si
    push di
.l:
    mov al,[si]
    mov ah,[di]
    cmp al,ah
    jne .df
    test al,al
    jz .eq
    inc si
    inc di
    jmp .l
.eq:
    xor ax,ax
    jmp .d
.df:
    mov ax,1
.d:
    pop di
    pop si
    ret

strcpy:
    push si
    push di
.c:
    lodsb
    stosb
    test al,al
    jnz .c
    pop di
    pop si
    ret

atoi:
    push bx
    xor ax,ax
    xor bx,bx
.l:
    lodsb
    cmp al,'0'
    jb .d
    cmp al,'9'
    ja .d
    sub al,'0'
    push ax
    mov ax,10
    mul bx
    pop bx
    add ax,bx
    mov bx,ax
    jmp .l
.d:
    mov ax,bx
    pop bx
    ret

skip_spaces:
    push si
.s:
    lodsb
    cmp al,' '
    je .s
    dec si
    mov ax,si
    pop si
    ret

get_word:
    push si
    call skip_spaces
    mov si,ax
    mov di,arg_buf
.c:
    lodsb
    cmp al,' '
    je .d
    cmp al,0
    je .d
    stosb
    jmp .c
.d:
    mov byte [di],0
    mov ax,arg_buf
    pop si
    ret

; ============ FAT12 ============
fat12_init:
    mov byte [fat1],0xF0
    mov byte [fat1+1],0xFF
    mov byte [fat1+2],0xFF
    mov byte [fat2],0xF0
    mov byte [fat2+1],0xFF
    mov byte [fat2+2],0xFF
    mov word [next_free],3
    mov si,setup_name
    call fat12_create_file
    mov si,user_cfg
    call fat12_create_file
    mov si,prompt_cfg
    call fat12_create_file
    mov si,boot_logo
    call fat12_create_file
    mov si,view_test
    call fat12_create_file
    ret

fat12_find_free:
    push cx
    mov cx,224
    mov di,root_dir
.f:
    cmp byte [di],0
    je .d
    cmp byte [di],0xE5
    je .d
    add di,32
    loop .f
    xor di,di
.d:
    pop cx
    ret

fat12_create_file:
    pusha
    call fat12_find_free
    test di,di
    jz .exit
    mov cx,11
    rep movsb
    mov byte [di+11],0x20
    mov word [di+26],0
    mov word [di+28],0
.exit:
    popa
    ret

fat12_find:
    push cx
    push si
    mov cx,224
    mov di,root_dir
.s:
    push cx
    mov cx,11
    push si
    push di
    repe cmpsb
    pop di
    pop si
    je .f
    pop cx
    add di,32
    loop .s
    xor ax,ax
    jmp .d
.f:
    pop cx
    mov ax,1
.d:
    pop si
    pop cx
    ret

fat12_exists:
    call fat12_find
    ret

fat12_delete:
    pusha
    call fat12_find
    test ax,ax
    jz .exit
    mov byte [di],0xE5
.exit:
    popa
    ret

fat12_list:
    pusha
    mov cx,224
    mov si,root_dir
    xor bx,bx
    mov si,lh
    call println
.l:
    cmp byte [si],0
    je .d
    cmp byte [si],0xE5
    je .n
    push si
    mov di,pbuf
    mov cx,8
.pn:
    lodsb
    cmp al,' '
    je .pe
    stosb
    loop .pn
.pe:
    mov al,' '
    stosb
    mov byte [di],0
    mov si,pbuf
    call print
    call println
    pop si
    inc bx
.n:
    add si,32
    dec cx
    jnz .l
.d:
    mov ax,bx
    call print_dec
    mov si,fm
    call println
    popa
    ret

lh db 'Files:',13,10,0
fm db ' file(s)',13,10,0

; ============ CONFIG WIZARD ============
config_wizard:
    mov byte [screen_color],0x1F
    call screen_clear
    mov dh,0
    mov dl,10
    mov si,wiz_title
    call print_at
    mov byte [screen_color],0x07
    mov dh,3
    mov dl,0
    mov si,wiz_welcome
    call println
    call println
    mov si,wiz_prompt
    call print
    call read_line
    cmp byte [input_buf],0
    jne .save
    mov si,def_user
    mov di,input_buf
    call strcpy
.save:
    mov si,input_buf
    mov di,username
    call strcpy
    mov si,setup_name
    call fat12_delete
    mov byte [screen_color],0x0A
    mov si,wiz_done
    call print
    mov si,username
    call println
    mov byte [screen_color],0x07
    mov si,wiz_press
    call println
    call keyboard_getc
    call screen_clear
    ret

wiz_title   db '  RUNIF OS 2.0 - SETUP  ',0
wiz_welcome db 'Welcome to RUNIF OS 2.0!',13,10,0
wiz_prompt  db 'Username: ',0
wiz_done    db 13,10,'Setup complete! Welcome, ',0
wiz_press   db 'Press any key...',0

config_load:
    mov si,cfg_ok
    call print
    mov si,ms_ok
    call println
    ret

cfg_ok db 'USER.CFG',0
ms_ok db ' [ OK ]',13,10,0

; ============ PAGED HELP ============
show_help:
    mov word [hpage],0
.ph:
    call screen_clear
    mov dh,0
    mov dl,0
    mov si,htitle
    call print_at
    mov dh,1
    mov dl,0
    mov si,hnav
    call println
    call println
    mov ax,[hpage]
    cmp ax,0
    jne .n1
    mov si,hp0
    call println
    jmp .wk
.n1:
    cmp ax,1
    jne .n2
    mov si,hp1
    call println
    jmp .wk
.n2:
    cmp ax,2
    jne .n3
    mov si,hp2
    call println
    jmp .wk
.n3:
    mov si,hp3
    call println
.wk:
    call keyboard_getc
    cmp al,'q'
    je .qt
    cmp al,'Q'
    je .qt
    cmp al,27
    je .qt
    cmp al,'n'
    je .nx
    cmp al,'N'
    je .nx
    cmp al,'p'
    je .pv
    cmp al,'P'
    je .pv
    jmp .wk
.nx:
    cmp word [hpage],3
    jae .wk
    inc word [hpage]
    jmp .ph
.pv:
    cmp word [hpage],0
    je .wk
    dec word [hpage]
    jmp .ph
.qt:
    call screen_clear
    ret

htitle db '=== HELP (N/P/Q) ===',0
hnav   db 'N=Next P=Prev Q=Quit',0

hp0 db 'FILE: dir ls cat touch rm del',13,10
    db '      mkdir ren copy',13,10,13,10
    db 'SYSTEM: help echo clear whoami',13,10
    db '        date time uname uptime',13,10
    db '        free ps ver reboot kill',13,10,0

hp1 db 'GAMES: snake pong tetris mines',13,10
    db '       tictac hangman blackjack',13,10
    db '       memory dice guess pacman',13,10
    db '       digger invaders frogger',13,10
    db '       breakout asteroids chess',13,10
    db '       checkers solitaire maze',13,10
    db '       flappy platformer racing',13,10,0

hp2 db 'APPS: calc sysinfo edit meminfo',13,10
    db '      ascii color prime fibo',13,10
    db '      fact convert todo typing',13,10
    db '      paint notenano filem',13,10
    db '      netstat ping disks clock',13,10
    db '      timer weather notes diary',13,10
    db '      calendar alarm stopwatch',13,10
    db '      music photo',13,10,0

hp3 db 'TOOLS: hexedit encrypt decrypt',13,10
    db '       compress archive find',13,10
    db '       sort wc diff patch',13,10
    db '       backup restore cron',13,10
    db '       managfile debug test',13,10
    db '       benchmark monitor',13,10
    db '       profiler traceroute',13,10
    db '       nslookup grep',13,10
    db 13,10,'WARNING: kill triggers KERNEL PANIC',13,10
    db '  1,000,000 lines of crash details',13,10,0

; ============ COMMANDS ============
cmd_dir:
    call fat12_list
    ret

cmd_ls:
    call fat12_list
    ret

cmd_cat:
    mov si,cat_err
    call println
    ret
cat_err db 'File not found',13,10,0

cmd_touch:
    mov si, input_buf
    call get_word
    mov si, ax
    call fat12_create_file
    mov si,t_msg
    call println
    ret
t_msg db 'File created',13,10,0

cmd_rm:
    mov si, input_buf
    call get_word
    mov si, ax
    call fat12_delete
    mov si,r_msg
    call println
    ret
r_msg db 'File deleted',13,10,0

cmd_del:
    jmp cmd_rm

cmd_mkdir:
    mov si,md_msg
    call println
    ret
md_msg db 'Directory created',13,10,0

cmd_ren:
    mov si,rn_msg
    call println
    ret
rn_msg db 'File renamed',13,10,0

cmd_copy:
    mov si,cp_msg
    call println
    ret
cp_msg db 'File copied',13,10,0

cmd_help:
    call show_help
    ret

cmd_echo:
    mov si,input_buf
    call skip_spaces
    mov si,ax
    call println
    ret

cmd_clear:
    call screen_clear
    ret

cmd_whoami:
    mov si,username
    call println
    ret

cmd_date:
    call print_moscow_time
    call println
    ret

cmd_time:
    mov al, [boot_hour]
    call bcd_to_bin
    call print_dec
    mov al, ':'
    call putc
    mov al, [boot_min]
    call bcd_to_bin
    call print_dec
    mov al, ':'
    call putc
    mov al, [boot_sec]
    call bcd_to_bin
    call print_dec
    mov al, ' '
    call putc
    mov si, msk_str
    call print
    call println
    ret

cmd_uname:
    mov si,uname_str
    call println
    ret

cmd_uptime:
    xor ah,ah
    int 0x1A
    mov ax,dx
    mov bx,18
    div bx
    call print_dec
    mov si,sec_str
    call println
    ret

cmd_free:
    int 0x12
    call print_dec
    mov si,kb_str
    call println
    ret

cmd_ps:
    mov si,ps_str
    call println
    ret

cmd_ver:
    mov si,ver_str
    call println
    ret

cmd_reboot:
    mov si,reb_str
    call println
    mov al,0xFE
    out 0x64,al
    ret

cmd_shutdown:
    mov si,sd_str
    call println
    cli
    hlt
    ret

cmd_kill:
    mov si,kill_msg
    call println
    mov si,panic_kill_reason
    push si
    jmp kernel_panic

kill_msg db 'Killing shell process (PID 2)...',13,10,0
panic_kill_reason db 'SHELL PROCESS (PID 2) WAS KILLED',13,10
                  db 'BY USER COMMAND: kill',0

; ============ SNAKE ============
cmd_snake:
    call screen_clear
    mov byte [snk_x],40
    mov byte [snk_y],12
    mov byte [snk_dx],1
    mov byte [snk_dy],0
    mov byte [snk_fx],20
    mov byte [snk_fy],10
    mov byte [snk_sc],0
    mov si,snk_t
    mov dh,0
    mov dl,0
    call print_at

.sl:
    call keyboard_has_key
    test ax,ax
    jz .sn
    call keyboard_getc
    cmp al,'w'
    je .su
    cmp al,'s'
    je .sd
    cmp al,'a'
    je .sl2
    cmp al,'d'
    je .sr
    cmp al,'q'
    je .sq
    cmp al,27
    je .sq
    jmp .sn

.su:
    cmp byte [snk_dy],1
    je .sn
    mov byte [snk_dx],0
    mov byte [snk_dy],-1
    jmp .sn
.sd:
    cmp byte [snk_dy],-1
    je .sn
    mov byte [snk_dx],0
    mov byte [snk_dy],1
    jmp .sn
.sl2:
    cmp byte [snk_dx],1
    je .sn
    mov byte [snk_dx],-1
    mov byte [snk_dy],0
    jmp .sn
.sr:
    cmp byte [snk_dx],-1
    je .sn
    mov byte [snk_dx],1
    mov byte [snk_dy],0

.sn:
    mov al,[snk_dx]
    add [snk_x],al
    mov al,[snk_dy]
    add [snk_y],al
    cmp byte [snk_x],80
    jb .xo
    mov byte [snk_x],0
.xo:
    cmp byte [snk_y],25
    jb .yo
    mov byte [snk_y],1
.yo:
    cmp byte [snk_y],1
    jae .dr
    mov byte [snk_y],24

.dr:
    mov ah,0x02
    mov bh,0
    mov dh,[snk_y]
    mov dl,[snk_x]
    int 0x10
    mov al,'O'
    mov ah,0x09
    mov bl,0x0A
    mov cx,1
    int 0x10
    mov dh,[snk_fy]
    mov dl,[snk_fx]
    mov ah,0x02
    int 0x10
    mov al,'*'
    mov ah,0x09
    mov bl,0x0C
    int 0x10
    mov al,[snk_x]
    cmp al,[snk_fx]
    jne .dl
    mov al,[snk_y]
    cmp al,[snk_fy]
    jne .dl
    inc byte [snk_sc]
    mov al,[snk_sc]
    mov [snk_fx],al
    add byte [snk_fx],5
    mov al,[snk_sc]
    mov [snk_fy],al
    add byte [snk_fy],3
    mov dh,0
    mov dl,70
    mov ah,0x02
    int 0x10
    mov si,sc_str
    call print
    mov al,[snk_sc]
    call print_dec

.dl:
    mov cx,0x8000
.dw:
    loop .dw
    jmp .sl

.sq:
    call screen_clear
    ret

snk_t db 'SNAKE - WASD/Q',0
sc_str db 'Score:',0

; ============ PONG ============
cmd_pong:
    call screen_clear
    mov byte [pong_bx],40
    mov byte [pong_by],12
    mov byte [pong_bdx],1
    mov byte [pong_bdy],1
    mov byte [pong_p1y],10
    mov byte [pong_p2y],10
    mov byte [pong_s1],0
    mov byte [pong_s2],0
    mov si,png_t
    mov dh,0
    mov dl,0
    call print_at

.pl:
    call keyboard_has_key
    test ax,ax
    jz .pn
    call keyboard_getc
    cmp al,'w'
    je .p1u
    cmp al,'s'
    je .p1d
    cmp al,'q'
    je .pq
    cmp al,27
    je .pq
    jmp .pn

.p1u:
    cmp byte [pong_p1y],2
    jbe .pn
    dec byte [pong_p1y]
    jmp .pn
.p1d:
    cmp byte [pong_p1y],21
    jae .pn
    inc byte [pong_p1y]

.pn:
    mov al,[pong_by]
    cmp al,[pong_p2y]
    je .mb
    jb .p2u
    inc byte [pong_p2y]
    jmp .mb
.p2u:
    dec byte [pong_p2y]

.mb:
    mov al,[pong_bdx]
    add [pong_bx],al
    mov al,[pong_bdy]
    add [pong_by],al
    cmp byte [pong_by],2
    jae .cb
    mov byte [pong_by],2
    neg byte [pong_bdy]
.cb:
    cmp byte [pong_by],23
    jbe .cp1
    mov byte [pong_by],23
    neg byte [pong_bdy]

.cp1:
    cmp byte [pong_bx],3
    jne .cp2
    mov al,[pong_by]
    mov ah,[pong_p1y]
    sub al,ah
    cmp al,-2
    jl .s2
    cmp al,2
    jg .s2
    mov byte [pong_bx],3
    neg byte [pong_bdx]
    jmp .pd

.cp2:
    cmp byte [pong_bx],76
    jne .pd
    mov al,[pong_by]
    mov ah,[pong_p2y]
    sub al,ah
    cmp al,-2
    jl .s1
    cmp al,2
    jg .s1
    mov byte [pong_bx],76
    neg byte [pong_bdx]
    jmp .pd

.s1:
    inc byte [pong_s1]
    mov byte [pong_bx],40
    mov byte [pong_by],12
    jmp .pd
.s2:
    inc byte [pong_s2]
    mov byte [pong_bx],40
    mov byte [pong_by],12

.pd:
    mov ah,0x02
    mov bh,0
    mov dh,[pong_by]
    mov dl,[pong_bx]
    int 0x10
    mov al,'O'
    mov ah,0x09
    mov bl,0x0F
    mov cx,1
    int 0x10
    mov cx,3
.p1dr:
    mov dh,[pong_p1y]
    add dh,cl
    sub dh,2
    mov dl,2
    mov ah,0x02
    int 0x10
    mov al,'|'
    mov ah,0x09
    mov bl,0x0A
    push cx
    mov cx,1
    int 0x10
    pop cx
    loop .p1dr
    mov cx,3
.p2dr:
    mov dh,[pong_p2y]
    add dh,cl
    sub dh,2
    mov dl,77
    mov ah,0x02
    int 0x10
    mov al,'|'
    mov ah,0x09
    mov bl,0x0C
    push cx
    mov cx,1
    int 0x10
    pop cx
    loop .p2dr
    mov dh,0
    mov dl,30
    mov ah,0x02
    int 0x10
    mov al,[pong_s1]
    add al,'0'
    call putc
    mov al,' '
    call putc
    mov al,[pong_s2]
    add al,'0'
    call putc
    mov cx,0x4000
.pdd:
    loop .pdd
    jmp .pl

.pq:
    call screen_clear
    ret

png_t db 'PONG - W/S to move, Q to quit',0

; ============ CALCULATOR ============
cmd_calc:
    call screen_clear
    mov si,c_title
    call println
    call println
    mov si,c_p1
    call print
    call read_line
    mov si,input_buf
    call atoi
    mov [cn1],ax
    mov si,c_p2
    call print
    call keyboard_getc
    mov [cop],al
    call putc
    call println
    mov si,c_p3
    call print
    call read_line
    mov si,input_buf
    call atoi
    mov [cn2],ax
    mov ax,[cn1]
    mov bx,[cn2]
    cmp byte [cop],'+'
    je .add
    cmp byte [cop],'-'
    je .sub
    cmp byte [cop],'*'
    je .mul
    cmp byte [cop],'/'
    je .div
    jmp .done
.add: add ax,bx
    jmp .res
.sub: sub ax,bx
    jmp .res
.mul: mul bx
    jmp .res
.div: test bx,bx
    jz .done
    xor dx,dx
    div bx
.res:
    mov [cres],ax
    mov si,c_eq
    call print
    mov ax,[cres]
    call print_dec
    call println
.done:
    mov si,c_ag
    call println
    call keyboard_getc
    call screen_clear
    ret

c_title db '=== CALCULATOR ===',0
c_p1 db 'Number 1: ',0
c_p2 db 'Operator (+-*/): ',0
c_p3 db 'Number 2: ',0
c_eq  db 'Result: ',0
c_ag  db 'Press any key...',0

; ============ SYSINFO ============
cmd_sysinfo:
    call screen_clear
    mov si,si_t
    call println
    call println
    mov si,si_os
    call println
    mov si,si_ar
    call println
    mov si,si_tz
    call println
    mov si,si_us
    call print
    mov si,username
    call println
    mov si,si_boot
    call print
    call print_moscow_time
    call println
    mov si,si_proc
    call println
    call println
    call keyboard_getc
    call screen_clear
    ret

si_t  db '=== SYSTEM INFO ===',0
si_os db 'OS: RUNIF OS 2.0',13,10,0
si_ar db 'Arch: x86 Real Mode',13,10,0
si_tz db 'Timezone: MSK (UTC+3)',13,10,0
si_us db 'User: ',0
si_boot db 'Boot: ',0
si_proc db 'Processes: PID 1=init, PID 2=shell',13,10,0

cmd_generic:
    call screen_clear
    mov si,gm
    call println
    call keyboard_getc
    call screen_clear
    ret
gm db 'Running... Press any key',0

uname_str db 'RUNIF OS 2.0 (Moscow Time)',13,10,0
ver_str   db 'RUNIF OS 2.0 (x86 Real Mode, FAT12, MSK)',13,10,0
sec_str   db ' seconds',13,10,0
kb_str    db ' KB',13,10,0
ps_str    db 'PID CMD',13,10,'  1 init',13,10,'  2 shell',13,10,0
reb_str   db 'Rebooting...',13,10,0
sd_str    db 'System halted',13,10,0

; ============ SHELL WITH PROCESS CHECK ============
shell_run:
    cmp byte [shell_pid], 2
    je .alive
    mov si, panic_shell_dead
    push si
    jmp kernel_panic

.alive:
    mov byte [screen_color],0x0A
    mov si,username
    call print
    mov al,'@'
    call putc
    mov si,hostname
    call print
    mov byte [screen_color],0x07
    mov si,shell_prompt
    call print
    call read_line
    cmp byte [input_buf],0
    je shell_run
    mov bx,cmd_table
.f:
    cmp word [bx],0
    je .nf
    mov si,input_buf
    mov di,[bx+2]
    call strcmp
    test ax,ax
    jz .fd
    add bx,4
    jmp .f
.fd:
    call [bx]
    jmp shell_run
.nf:
    mov si,input_buf
    call print
    mov si,nf_msg
    call println
    jmp shell_run

nf_msg db ': command not found',13,10,0
panic_shell_dead db 'SHELL PROCESS (PID 2) UNEXPECTEDLY TERMINATED',13,10
                 db 'THE MAIN USER INTERFACE IS GONE',0

cmd_table:
    dw cmd_dir,    str_dir
    dw cmd_ls,     str_ls
    dw cmd_cat,    str_cat
    dw cmd_touch,  str_touch
    dw cmd_rm,     str_rm
    dw cmd_del,    str_del
    dw cmd_mkdir,  str_mkdir
    dw cmd_ren,    str_ren
    dw cmd_copy,   str_copy
    dw cmd_help,   str_help
    dw cmd_echo,   str_echo
    dw cmd_clear,  str_clear
    dw cmd_whoami, str_whoami
    dw cmd_date,   str_date
    dw cmd_time,   str_time
    dw cmd_uname,  str_uname
    dw cmd_uptime, str_uptime
    dw cmd_free,   str_free
    dw cmd_ps,     str_ps
    dw cmd_ver,    str_ver
    dw cmd_reboot, str_reboot
    dw cmd_shutdown, str_shutdown
    dw cmd_kill,   str_kill
    dw cmd_snake,  str_snake
    dw cmd_pong,   str_pong
    dw cmd_calc,   str_calc
    dw cmd_sysinfo, str_sysinfo
    dw cmd_generic, str_edit
    dw cmd_generic, str_meminfo
    dw cmd_generic, str_ascii
    dw cmd_generic, str_color
    dw cmd_generic, str_tetris
    dw cmd_generic, str_mines
    dw cmd_generic, str_tictac
    dw cmd_generic, str_hangman
    dw cmd_generic, str_blackjack
    dw cmd_generic, str_memory
    dw cmd_generic, str_dice
    dw cmd_generic, str_guess
    dw cmd_generic, str_pacman
    dw cmd_generic, str_digger
    dw cmd_generic, str_invaders
    dw cmd_generic, str_frogger
    dw cmd_generic, str_breakout
    dw cmd_generic, str_asteroids
    dw cmd_generic, str_chess
    dw cmd_generic, str_checkers
    dw cmd_generic, str_solitaire
    dw cmd_generic, str_maze
    dw cmd_generic, str_flappy
    dw cmd_generic, str_platformer
    dw cmd_generic, str_racing
    dw cmd_generic, str_prime
    dw cmd_generic, str_fibo
    dw cmd_generic, str_fact
    dw cmd_generic, str_convert
    dw cmd_generic, str_todo
    dw cmd_generic, str_typing
    dw cmd_generic, str_paint
    dw cmd_generic, str_notenano
    dw cmd_generic, str_filem
    dw cmd_generic, str_netstat
    dw cmd_generic, str_ping
    dw cmd_generic, str_disks
    dw cmd_generic, str_clock
    dw cmd_generic, str_timer
    dw cmd_generic, str_weather
    dw cmd_generic, str_notes
    dw cmd_generic, str_diary
    dw cmd_generic, str_calendar
    dw cmd_generic, str_alarm
    dw cmd_generic, str_stopwatch
    dw cmd_generic, str_music
    dw cmd_generic, str_photo
    dw cmd_generic, str_hexedit
    dw cmd_generic, str_encrypt
    dw cmd_generic, str_decrypt
    dw cmd_generic, str_compress
    dw cmd_generic, str_archive
    dw cmd_generic, str_find
    dw cmd_generic, str_sort
    dw cmd_generic, str_wc
    dw cmd_generic, str_diff
    dw cmd_generic, str_patch
    dw cmd_generic, str_backup
    dw cmd_generic, str_restore
    dw cmd_generic, str_cron
    dw cmd_generic, str_managfile
    dw cmd_generic, str_debug
    dw cmd_generic, str_test
    dw cmd_generic, str_benchmark
    dw cmd_generic, str_monitor
    dw cmd_generic, str_profiler
    dw cmd_generic, str_traceroute
    dw cmd_generic, str_nslookup
    dw cmd_generic, str_grep
    dw 0,0

str_dir     db 'dir',0
str_ls      db 'ls',0
str_cat     db 'cat',0
str_touch   db 'touch',0
str_rm      db 'rm',0
str_del     db 'del',0
str_mkdir   db 'mkdir',0
str_ren     db 'ren',0
str_copy    db 'copy',0
str_help    db 'help',0
str_echo    db 'echo',0
str_clear   db 'clear',0
str_whoami  db 'whoami',0
str_date    db 'date',0
str_time    db 'time',0
str_uname   db 'uname',0
str_uptime  db 'uptime',0
str_free    db 'free',0
str_ps      db 'ps',0
str_ver     db 'ver',0
str_reboot  db 'reboot',0
str_shutdown db 'shutdown',0
str_kill    db 'kill',0
str_snake   db 'snake',0
str_pong    db 'pong',0
str_calc    db 'calc',0
str_sysinfo db 'sysinfo',0
str_edit    db 'edit',0
str_meminfo db 'meminfo',0
str_ascii   db 'ascii',0
str_color   db 'color',0
str_tetris  db 'tetris',0
str_mines   db 'mines',0
str_tictac  db 'tictac',0
str_hangman db 'hangman',0
str_blackjack db 'blackjack',0
str_memory  db 'memory',0
str_dice    db 'dice',0
str_guess   db 'guess',0
str_pacman  db 'pacman',0
str_digger  db 'digger',0
str_invaders db 'invaders',0
str_frogger db 'frogger',0
str_breakout db 'breakout',0
str_asteroids db 'asteroids',0
str_chess   db 'chess',0
str_checkers db 'checkers',0
str_solitaire db 'solitaire',0
str_maze    db 'maze',0
str_flappy  db 'flappy',0
str_platformer db 'platformer',0
str_racing  db 'racing',0
str_prime   db 'prime',0
str_fibo    db 'fibo',0
str_fact    db 'fact',0
str_convert db 'convert',0
str_todo    db 'todo',0
str_typing  db 'typing',0
str_paint   db 'paint',0
str_notenano db 'notenano',0
str_filem   db 'filem',0
str_netstat db 'netstat',0
str_ping    db 'ping',0
str_disks   db 'disks',0
str_clock   db 'clock',0
str_timer   db 'timer',0
str_weather db 'weather',0
str_notes   db 'notes',0
str_diary   db 'diary',0
str_calendar db 'calendar',0
str_alarm   db 'alarm',0
str_stopwatch db 'stopwatch',0
str_music   db 'music',0
str_photo   db 'photo',0
str_hexedit db 'hexedit',0
str_encrypt db 'encrypt',0
str_decrypt db 'decrypt',0
str_compress db 'compress',0
str_archive db 'archive',0
str_find    db 'find',0
str_sort    db 'sort',0
str_wc      db 'wc',0
str_diff    db 'diff',0
str_patch   db 'patch',0
str_backup  db 'backup',0
str_restore db 'restore',0
str_cron    db 'cron',0
str_managfile db 'managfile',0
str_debug   db 'debug',0
str_test    db 'test',0
str_benchmark db 'benchmark',0
str_monitor db 'monitor',0
str_profiler db 'profiler',0
str_traceroute db 'traceroute',0
str_nslookup db 'nslookup',0
str_grep    db 'grep',0

; ============ KERNEL ENTRY ============
kernel_start:
    mov ax,0x1000
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov sp,0xFFFE
    
    call cmos_get_time
    mov byte [init_pid], 1
    
    call screen_init
    call keyboard_init
    
    mov byte [screen_color],0x1F
    call screen_clear
    
    mov dh,0
    mov dl,0
    mov si,banner
    call print_at
    
    mov byte [screen_color],0x07
    mov dh,2
    mov dl,0
    
    mov si,boot_time_msg
    call print
    call print_moscow_time
    call println
    
    mov si,init_sys
    call print
    mov si,ms_ok
    call println
    
    mov si,init_kb
    call print
    mov si,ms_ok
    call println
    
    call fat12_init
    
    mov si,init_fs
    call print
    mov si,ms_ok
    call println
    
    mov si,init_proc
    call print
    mov si,ms_ok
    call println
    
    mov si,setup_name
    call fat12_exists
    cmp ax,1
    jne .skip_setup
    
    call println
    call config_wizard

.skip_setup:
    call println
    call config_load
    call println
    
    mov si,init_ready
    call print
    mov si,ms_ok
    call println
    call println
    
    mov byte [screen_color],0x0E
    mov si,welcome_msg
    call print
    mov si,username
    call println
    
    mov byte [screen_color],0x0F
    mov si,hint_msg
    call println
    
    mov byte [screen_color],0x07
    call println
    
    mov byte [shell_pid], 2
    
    call shell_run
    jmp $

banner db '  RUNIF OS 2.0  ',0
boot_time_msg db 'Boot time (MSK): ',0
init_sys db 'Hardware init',0
init_kb db 'Keyboard driver',0
init_fs db 'FAT12 filesystem',0
init_proc db 'Process manager (PID 1=init)',0
init_ready db 'System ready',0
welcome_msg db 13,10,'Welcome, ',0
hint_msg db 'Type help for commands',0
