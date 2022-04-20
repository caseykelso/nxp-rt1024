#!/bin/sh
gcc-arm-none-eabi-7-2017-q4-major/bin/arm-none-eabi-gdb -s build.sha/Debug/sha.elf -ex "target remote localhost:2331"


