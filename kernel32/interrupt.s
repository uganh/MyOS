    .global Init_IDTR

Init_IDTR:
    # Initialize IDTR
    pushl   %eax
    pushl   %ecx
    pushl   %edx
    pushl   %esi

    # Interrupt 0x20
    movl    $Timer_interrupt,   %edx
    movw    $0x8e00,%dx
    movl    $0x00080000,    %eax
    movw    $Timer_interrupt,   %ax
    movl    $0x20,  %ecx
    leal    IDT(, %ecx, 8), %esi
    movl    %eax,   (%esi)
    movl    %edx,   4(%esi)

    # Interrupt 0x21
    movl    $Keyboard_interrupt,%edx
    movw    $0x8e00,%dx
    movl    $0x00080000,    %eax
    movw    $Keyboard_interrupt,%ax
    movl    $0x21,  %ecx
    leal    IDT(, %ecx, 8), %esi
    movl    %eax,   (%esi)
    movl    %edx,   4(%esi)

    lidt    IDT_48

    popl    %esi
    popl    %edx
    popl    %ecx
    popl    %eax
    ret

IDT_48:
    .word   (IDTEnd - IDT) - 1
    .long   0x7e00 + IDT

    # Interrupt descriptor table
IDT:
    .fill   256, 8, 0
IDTEnd:

Timer_interrupt:
    # Timer interrupt handler
    # Display `Foo` and `Bar` alternately

    call    Enable_8259A
    
    subl    $10,    Milsec
    jne     2f

    # Reset
    movl    $1000,  Milsec
    
    xorl    $1,     Status
    je      0f
    pushl   MsgLen1
    pushl   $Msg1
    jmp     1f
0:
    pushl   MsgLen0
    pushl   $Msg0
1:
    call    Display
    addl    $8,     %esp

2:
    iret

Milsec:
    .long   1000
Status:
    .long   0

Msg0:
    .ascii  "Foo"
MsgLen0:
    .long   . - Msg0
Msg1:
    .ascii  "Bar"
MsgLen1:
    .long   . - Msg1

Keyboard_interrupt:
    # Keyboard interrupt handler

    call    Enable_8259A
    call    Enable_keyboard
    
    # Release key
    pushl   MsgLen
    pushl   $Msg
    call    Display
    addl    $8,     %esp

0:
    iret

Msg:
    .ascii  "233"
MsgLen:
    .long   . - Msg
