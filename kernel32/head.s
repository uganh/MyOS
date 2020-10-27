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
    pushl   $MsgStr
    call    Display

    call    Init_8259A

    # Interrupt every 10 ms
    movw    $11931, %cx
    call    Init_8253

    call    Init_IDTR

    sti

    jmp     .

    # Read-only data
MsgStr:
    .ascii  "Kernel start"
MsgLen:
    .long   . - MsgStr
