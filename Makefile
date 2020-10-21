boot: boot.o
	ld --oformat binary -Ttext=0x7c00 -o boot boot.o

boot.o: boot.s
	as -o boot.o boot.s

boot.img: boot
	dd if=/dev/zero of=boot.img bs=512 count=2880
	dd if=boot of=boot.img bs=512 count=1 seek=0 conv=notrunc

	sudo mount boot.img /media/ -t vfat -o loop
	#sudo touch /media/test
	#sudo touch /media/another
	sudo touch /media/loader
	sudo sync
	sudo umount /media/

test: boot.img
	bochs -q -f .bochsrc

clean:
	rm -f boot boot.o boot.img
