OUTPUT_FORMAT(elf32-i386)
ENTRY(start)
SECTIONS { . = 1M; .multiboot : { KEEP(*(.multiboot)) } .text : { *(.text) *(.text.*) *(.rodata*) } .data : { *(.data) *(.data.*) } .bss : { *(COMMON) *(.bss) *(.bss.*) } _end = .; }
