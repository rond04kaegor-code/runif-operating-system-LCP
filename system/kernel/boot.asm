[BITS 32]
[GLOBAL start]
[EXTERN runifkernel_main]

MULTIBOOT_MAGIC    equ 0x1BADB002
MULTIBOOT_FLAGS    equ 0x00000003
MULTIBOOT_CHECKSUM equ -(MULTIBOOT_MAGIC+MULTIBOOT_FLAGS)

section .multiboot
    dd MULTIBOOT_MAGIC
    dd MULTIBOOT_FLAGS
    dd MULTIBOOT_CHECKSUM

section .text
start:
    mov esp, 0x200000
    push eax
    push ebx
    call runifkernel_main
    cli
.hang:
    hlt
    jmp .hang
