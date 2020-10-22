bootloader: boot loader
	if [ ! -e "boot.img" ]; then dd if=/dev/zero of=boot.img bs=512 count=2880; fi
	dd if=boot of=boot.img bs=512 count=1 seek=0 conv=notrunc
	sudo mount boot.img /media/ -t vfat -o loop
	sudo cp loader /media/
	sudo sync
	sudo umount /media/

boot: boot.s
	as -o boot.o boot.s
	ld --oformat binary -Ttext=0x7c00 -o boot boot.o

loader: loader.s
	as -o loader.o loader.s
	ld --oformat binary -Ttext=0x0 -o loader loader.o

clean:
	rm -rf boot loader *.o
