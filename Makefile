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

kernel: kernel32/head.s kernel32/interrupt.s driver
	as --32 -o head.o kernel32/head.s
	as --32 -o interrupt.o kernel32/interrupt.s
	ld -m elf_i386 --oformat binary -Ttext=0 -o kernel head.o interrupt.o 8253.o 8259A.o display.o keyboard.o

driver: kernel32/driver/8253.s kernel32/driver/8259A.s kernel32/driver/display.s kernel32/driver/keyboard.s
	as --32 -o 8253.o kernel32/driver/8253.s
	as --32 -o 8259A.o kernel32/driver/8259A.s
	as --32 -o display.o kernel32/driver/display.s
	as --32 -o keyboard.o kernel32/driver/keyboard.s

clean:
	rm -rf boot kernel *.o
