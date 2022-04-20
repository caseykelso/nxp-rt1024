#!/bin/sh
gcc-arm-none-eabi-7-2017-q4-major/bin/arm-none-eabi-gdb -s build.firmware-slot1/Debug/firmware-slot1.elf -ex "target remote localhost:2331"


