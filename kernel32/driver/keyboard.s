    .global Init_keybord, Interrupt_0x21

Init_keybord:
    # Initialize keyboard
    # Registers: 0x60, 0x61
    # Interrupt: 0x20

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

Interrupt_0x21:
    # Interrupt handler

    call    Enable_8259A
    call    Enable_keyboard

    xorl    $1,     Status
    jne     0f
    
    # Release keyboard
    pushl   MsgEnd0 - Msg0
    pushl   $Msg0
    call    Display
    addl    $8,     %esp

0:
    iret

    # Global data
Status:
    .long   0

    # Read-only data
Msg:
    .ascii  "233"
MsgEnd: