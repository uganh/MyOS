Kernel:
    # Set segment
    movw    $0x10,  %ax
    movw    %ax,    %ds
    movw    $0x18,  %ax
    movw    %ax,    %ss
    movw    $0x20,  %ax
    movw    %ax,    %es

    # Set stack
    movl    $512,   %esp

    pushl   MsgLen
    pushl   $Msg
    call    Display
    addl    $8,     %esp

    call    Init_8259A

    # Interrupt every 10 ms
    pushl   $11931
    call    Init_8253
    addl    $4,     %esp

    call    Init_keyboard

    pushl   $0xfffc
    call    Mask_8259A
    addl    $4,     %esp

    call    Init_IDTR

    sti

    jmp     .

    # Read-only data
Msg:
    .ascii  "Kernel start"
MsgLen:
    .long   . - Msg