#!/bin/bash

dd if=/dev/zero of=boot.img bs=512 count=2880
dd if=boot of=boot.img bs=512 count=1 seek=0 conv=notrunc

sudo mount boot.img /media/ -t vfat -o loop
sudo cp test.txt /media/
sudo cp test.txt /media/another.txt
sudo sync
sudo umount /media/

bochs -q -f .bochsrc
