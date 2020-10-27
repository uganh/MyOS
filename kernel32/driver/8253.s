    .global Init_8253

Init_8253:
    # Initialize programmable timer (0)
    # Frequency: 1193180Hz
    # Registers: 0x43, 0x40
    #
    # Parameters
    #   %cx: Latch

    pushl   %eax

    movb    $0x36,  %al
    outb    %al,    $0x43

    outb    %cl,    $0x40
    movb    %ch,    %cl
    outb    %cl,    $0x40

    popl    %eax
    ret
