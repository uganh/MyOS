#!/bin/bash

dd if=/dev/zero of=disk.img bs=512 count=2048
dd if=boot of=disk.img seek=0 bs=512 count=1 conv=notrunc

bochs -q -f .bochsrc
