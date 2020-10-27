    .global Init_8259A, Mask_8259A

Init_8259A:
    # Initialize the clock interrupt controller
    # Registers
    #   Master: 0x20, 0x21
    #   Slaver: 0xa0, 0xa1

    pushl   %eax

    movb    $0x11,  %al
    outb    %al,    $0x20
    outb    %al,    $0xa0

    # Set interrupt number
    movb    $0x20,  %al
    outb    %al,    $0x21
    movb    $0x28,  %al
    outb    %al,    $0xa1

    # Link slaver to master (IR2)
    movb    $0x04,  %al
    outb    %al,    $0x21
    movb    $0x02,  %al
    outb    %al,    $0xa1

    # Set mode
    movb    $0x01,  %al
    outb    %al,    $0x21
    outb    %al,    $0xa1

    popl    %eax
    ret

Mask_8259A:
    # Mask interrupt
    #
    # Parameters
    #   %ax: Mask code

    outb    %al,    $0x21
    movb    %ah,    %al
    outb    %al,    $0xa1

    ret

Enable_8259A:
    # Enable
    #
    # Parameters
    pushl   %eax
    
    movb    $0x20,  %al
    outb    %al,    $0x20
    outb    %al,    $0xa0
    
    popl    %eax
    ret