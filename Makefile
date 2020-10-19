boot: boot.o
	ld --oformat binary -Ttext=0x7c00 -o boot boot.o

boot.o: boot.s
	as -o boot.o boot.s

clean:
	rm -f boot boot.o

