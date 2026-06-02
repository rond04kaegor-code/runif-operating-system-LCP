OUTPUT_FORMAT(elf32-i386)
SECTIONS { . = 0x1000; .text : { *(.text) *(.text.*) *(.rodata*) } .data : { *(.data) *(.data.*) } .bss : { *(COMMON) *(.bss) *(.bss.*) } }
