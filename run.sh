#!/bin/bash

dd if=/dev/zero of=boot.img bs=512 count=2880
dd if=boot of=boot.img seek=0 bs=512 count=1 conv=notrunc

bochs -q -f .bochsrc
