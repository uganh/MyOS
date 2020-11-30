    .global Key_ascii
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

    # Save key
    xorl    %eax,   %eax
    inb     $0x60,  %al
    movb    Keymap(,%eax,1),%al
    movb    %al,    Key_ascii

    inb     $0x61,  %al
    orb     $0x80,  %al
    outb    %al,    $0x61
    andb    $0x7f,  %al
    outb    %al,    $0x61

    popl    %eax
    ret

Key_ascii:
    .byte   0

    # Read-only data
Keymap:
    .byte   0, 0
    .ascii  "1234567890"
    .byte   0, 0, 0, 0
    .ascii  "qwertyuiop"
    .byte   0, 0, 0, 0
    .ascii  "asdfghjkl"
    .byte   0, 0, 0, 0, 0
    .ascii  "zxcvbnm"
