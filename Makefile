boot: boot.o
	ld --oformat binary -Ttext=0x7c00 -o boot boot.o

boot.o: boot.s
	as -o boot.o boot.s

boot.img: boot
	if [ ! -e "boot.img" ]; then dd if=/dev/zero of=boot.img bs=512 count=2880; fi
	dd if=boot of=boot.img bs=512 count=1 seek=0 conv=notrunc

test: boot.img
	bochs -q -f .bochsrc

clean:
	rm -rf boot boot.o
