#!/bin/bash
qemu-system-i386 -fda "$HOME/runifkernel/iso/runif-os-2.0.img" -boot a -m 256M -rtc base=utc
