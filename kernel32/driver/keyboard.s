    .global Init_keyboard, Interrupt_0x21

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

Interrupt_0x21:
    # Interrupt handler

    call    Enable_8259A
    call    Enable_keyboard

    xorl    $1,     Status
    je      0f
    
    # Release keyboard
    pushl   MsgLen
    pushl   $Msg
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
MsgLen:
    .long   . - Msg
