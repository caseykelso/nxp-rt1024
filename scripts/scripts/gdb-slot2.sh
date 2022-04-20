#!/bin/sh
gcc-arm-none-eabi-7-2017-q4-major/bin/arm-none-eabi-gdb -s build.firmware-slot2/Debug/firmware-slot2.elf -ex "target remote localhost:2331"


