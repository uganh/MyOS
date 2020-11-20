    .global Init_8253

    # Frequency: 1193180Hz
    # Registers: 0x43, 0x40
    # Interrupt: 0x20

Init_8253:
    # Initialize programmable timer (0)
    #
    # Parameters
    #   %ax: Latch

    pushl   %eax
    movb    $0x36,  %al
    outb    %al,    $0x43
    popl    %eax

    outb    %al,    $0x40
    movb    %ah,    %al
    outb    %al,    $0x40

    ret
