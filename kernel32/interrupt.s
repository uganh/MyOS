    .global Init_IDTR

Init_IDTR:
    # Initialize IDTR
    pushl   %eax
    pushl   %ecx
    pushl   %edx
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
    popl    %edx
    popl    %ecx
    popl    %eax
    ret

TimerInterrupt:
    call    Enable_8259A
    
    subl    $10,    Milsec
    jne     2f
    
    # Reset
    movl    $1000,  Milsec
    
    xorl    $1,     Switch
    je      0f
    pushl    Len1
    pushl    $Msg1
    jmp     1f
0:
    pushl    Len0
    pushl    $Msg0
1:
    call    Display
    addl    $8,     %esp

2:
    iret

IDT_48:
    .word   (IDTEnd - IDT) - 1
    .long   0x7e00 + IDT

    # Interrupt descriptor table
IDT:
    .fill   256, 8, 0
IDTEnd:

    # Global data
Milsec:
    .long   1000
Switch:
    .long   0

    # Read-only data
Msg0:
    .ascii  "Foo"
Len0:
    .long   . - Msg0
Msg1:
    .ascii  "Bar"
Len1:
    .long   . - Msg1
