    .global Init_IDTR

Init_IDTR:
    # Initialize IDTR
    pushl   %esi

    # Timer interrupt
    movl    $TimerInterrupt,%edx
    movw    $0x8e00,%dx
    movl    $0x00080000,    %eax
    movw    $TimerInterrupt,%ax
    movl    $0x20,  %ecx
    leal    IDT(, %ecx, 8), %esi
    movl    %eax,   (%esi)
    movl    %edx,   4(%esi)

    lidt    IDT_48

    popl    %esi
    ret

TimerInterrupt:
    call    Enable_8259A
    
    subl    $10,    Milsec
    jne     1f
    
    # Reset
    movl    $1000,  Milsec
    
    xorl    $1,     Switch
    je      0f

    pushl   Len1
    pushl   $Msg1
    call    Display
    jmp     1f
0:
    pushl   Len0
    pushl   $Msg0
    call    Display

1:
    iret

IDT_48:
    .word   (IDTEnd - IDT) - 1
    .int    0x7e00 + IDT

    # Interrupt descriptor table
IDT:
    .fill   256, 8, 0
IDTEnd:

    # Global data
Milsec:
    .word   1000
Switch:
    .word   0

    # Read-only data
Msg0:
    .ascii  "Foo"
Len0:
    .word   . - Msg0
Msg1:
    .ascii  "Bar"
Len1:
    .word   . - Msg0
