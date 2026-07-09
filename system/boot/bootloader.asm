[ORG 0x7C00]
[BITS 16]
start:
    xor ax,ax
    mov ds,ax
    mov es,ax
    mov ss,ax
    mov sp,0x7C00
    mov [drv],dl
    mov si,m1
    call p
    
    ; Load 128 sectors (64KB)
    mov ah,0x02
    mov al,128
    mov ch,0
    mov cl,2
    mov dh,0
    mov dl,[drv]
    mov bx,0x1000
    mov es,bx
    xor bx,bx
    int 0x13
    jc e
    
    mov si,m2
    call p
    jmp 0x1000:0x0000
e:  mov si,m3
    call p
    xor ah,ah
    int 0x16
    int 0x19
p:  lodsb
    or al,al
    jz .d
    mov ah,0x0E
    mov bx,0x0007
    int 0x10
    jmp p
.d: ret
m1 db 13,10,'RUNIF OS 2.0',13,10,'Loading...',0
m2 db ' OK',13,10,'Booting...',13,10,0
m3 db 13,10,'ERROR!',0
drv db 0
times 510-($-$$) db 0
dw 0xAA55
