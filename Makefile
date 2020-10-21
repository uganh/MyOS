bootloader: boot loader
	if [ ! -e "boot.img" ]; then dd if=/dev/zero of=boot.img bs=512 count=2880; fi
	dd if=boot of=boot.img bs=512 count=1 seek=0 conv=notrunc

boot: boot.o
	ld --oformat binary -Ttext=0x7c00 -o boot boot.o

boot.o: boot.s
	as -o boot.o boot.s

loader: loader.o
	ld --oformat binary -Ttext=0x10000 -o loader loader.o

loader.o:
	as -o loader.o loader.s

boot.img: boot loader


test:
	bochs -q -f .bochsrc

clean:
	rm -rf boot loader *.o
