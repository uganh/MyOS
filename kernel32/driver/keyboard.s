    .global Init_keyboard, Enable_keyboard

    # Registers: 0x60, 0x61
    # Interrupt: 0x21

Init_keyboard:
    # Initialize keyboard

    pushl   %eax

    inb     $0x61,  %al
    orb     $0x80,  %al
    outb    %al,    $0x61
    andb    $0x7f,  %al
    outb    %al,    $0x61

    popl    %eax
    ret

Enable_keyboard:
    # Enable keyboard

    pushl   %eax

    inb     $0x60,  %al
    inb     $0x61,  %al
    orb     $0x80,  %al
    outb    %al,    $0x61
    andb    $0x7f,  %al
    outb    %al,    $0x61

    popl    %eax
    ret
