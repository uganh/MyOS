boot: boot.o
	ld --oformat binary -Ttext=0x7c00 -o boot boot.o

boot.o: boot.s
	as -o boot.o boot.s

test: boot
	bash run.sh

clean:
	rm -f boot boot.o

