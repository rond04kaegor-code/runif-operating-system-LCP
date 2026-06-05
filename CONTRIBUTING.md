# Contributing to RUNIF OS

Thank you for your interest in contributing to RUNIF OS! This document provides guidelines for developing programs and contributing to the operating system.

---

## Coding Standards

All code must follow these conventions:

### Language Requirements

| Component | Language |
|-----------|----------|
| Kernel | C, Assembly (NASM) |
| Drivers | C |
| Programs (.prg) | C, C++ |
| Packages (.rinst) | C (generates .prg) |
| Scripts (.ss) | RSDBASH script |

### Naming Conventions

- **Functions**: Use lowercase with underscores
  ```c
  void load_file(void);
  void print_string(const char* s);
  int calculate_checksum(void);
```

· Constants: Use UPPERCASE with underscores
  ```c
  #define BUFFER_SIZE 512
  #define MAX_FILENAME 32
  #define VGA_MEMORY 0xB8000
  ```
· Variables: Use lowercase with underscores
  ```c
  char file_buffer[512];
  int current_position;
  int error_flag;
  ```

Code Formatting

· Use 4 spaces for indentation (no tabs)
· Place function braces on their own line
· Add blank lines between functions for readability

Example:

```c
void print_hello(void) {
    tty_puts("Hello, RUNIF OS!\n");
}

int add_numbers(int a, int b) {
    return a + b;
}
```

Function Documentation

For complex functions, add a documentation header using this format:

```c
/*
 * function_name - Brief description of what the function does
 * @param1: Description of first parameter
 * @param2: Description of second parameter
 * Returns: Description of return value
 * Note: Additional notes or warnings
 */
int function_name(int param1, int param2) {
    // Implementation
    return result;
}
```

Comments

· Use comments to explain why code does something, not what it does
· Complex algorithms should have explanatory comments
· Keep comments concise and in English

Good:

```c
// Convert LBA to CHS for BIOS compatibility
int chs = lba_to_chs(lba);
```

Avoid:

```c
// Move value to variable
int chs = lba_to_chs(lba);
```

---

Writing Programs for RUNIF OS

Program Structure

All programs must:

1. Be written in C or C++
2. Include tty.h and keyboard.h for I/O
3. Have a void program_name_main(void) entry point
4. Compile with -m32 -ffreestanding -nostdlib flags
5. Be output as .prg file

Minimal Program Template:

```c
#include "../drivers/tty.h"
#include "../drivers/keyboard.h"

void myprogram_main(void) {
    tty_puts("=== My Program v1.0 ===\n");
    tty_puts("Hello from RUNIF OS!\n");
}
```

.rinst Package Format

For installable packages, create a .rinst file:

```
Byte 0-4:   Magic header "RINST"
Byte 5:     Number of files
For each file:
  Byte 0-31:  Filename (32 bytes, null-padded)
  Byte 32-33: File size (little-endian)
  Byte 34+:   File content
```

Testing Your Program

1. Place your .c file in the system/programs/ directory
2. Rebuild: bash build.sh
3. Run in QEMU: qemu-system-i386 -cdrom iso/runif-os-1.0.iso -m 256M
4. Test all functionality thoroughly
5. Handle errors gracefully

---

Submitting Contributions

Before Submitting

· Code follows the style guidelines above
· Program has been tested in QEMU
· No bugs or crashes detected
· All comments and descriptions are in English

How to Submit

Method Address
Telegram @Egor_B_2016
E-mail lcp.yourename@internet.ru

What to Include

1. Source code (.c, .h, .asm files)
2. Brief description of what it does
3. Your name/nickname for credits
4. Any special build instructions

---

Creating Issues

When reporting bugs or suggesting features:

1. Search existing issues to avoid duplicates
2. Provide clear, descriptive titles
3. Include:
   · Steps to reproduce (for bugs)
   · Expected vs actual behavior
   · System information (QEMU version, real hardware, etc.)
   · Screenshots if applicable

Issue Template:

```
**Description:**
Brief description of the bug or feature request

**Steps to Reproduce:** (for bugs)
1. Start the OS
2. Run command X
3. Observe error Y

**Expected Behavior:**
What should happen

**Actual Behavior:**
What actually happens

**Environment:**
- RUNIF OS version: 1.0
- Hardware: Real PC / QEMU / VirtualBox
- Disk: USB Flash 4GB / Virtual Disk
```

---

Communication

Questions and Discussions

[!IMPORTANT]
Do not create GitHub issues for general questions or discussions.

Instead:

· Telegram: @Egor_B_2016
· E-mail: lcp.yourename@internet.ru

Language Requirements

[!IMPORTANT]
All code comments, issue descriptions, and documentation must be written in English. This ensures the project remains accessible to the international community.

Acceptable:

· Code comments in English
· Issue titles in English
· README updates in English

Not Acceptable:

· Code comments in other languages
· Issues with non-English descriptions

---

⏳ Response Time

We do our best to reply to every message.
If you haven't received a response within 7–10 days, please remind us.
We will definitely review your contribution!

---

License

By contributing to RUNIF OS, you agree that your contributions will be licensed under the RUNIF General Public License (RGPL) v1.0.

See LICENSE.md for full terms.

---

<div align="center">

Thank you for contributing to RUNIF OS!

Made with ❤️ by RUNIF OS Development LCP CORPORATION

</div>
