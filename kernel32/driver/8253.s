    .global Init_8253

    # Frequency: 1193180Hz
    # Registers: 0x43, 0x40
    # Interrupt: 0x20

Init_8253:
    # Initialize programmable timer (0)
    #
    # Parameters
    #   0x8(%ebp): Latch

    pushl   %ebp
    movl    %esp,   %ebp
    pushl   %eax

    movb    $0x36,  %al
    outb    %al,    $0x43

    movl    8(%ebp),%eax
    outb    %al,    $0x40
    movb    %ah,    %al
    outb    %al,    $0x40

    popl    %eax
    popl    %ebp
    ret
