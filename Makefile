os32: boot kernel
	if [ ! -e "boot.img" ]; then dd if=/dev/zero of=boot.img bs=512 count=2880; fi
	dd if=boot of=boot.img bs=512 count=1 seek=0 conv=notrunc
	sudo mount boot.img /media/ -t vfat -o loop
	sudo cp kernel /media/
	sudo sync
	sudo umount /media/

boot: boot.s
	as -o boot.o boot.s
	ld --oformat binary -Ttext=0x7c00 -o boot boot.o

kernel: kernel32/head.s
	as --32 -o head.o kernel32/head.s
	ld -m elf_i386 --oformat binary -Ttext=0 -o kernel head.o

clean:
	rm -rf boot kernel *.o
