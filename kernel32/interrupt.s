    .global Init_IDTR

Init_IDTR:
    # Initialize IDTR
    pushl   %eax
    pushl   %ecx
    pushl   %edx
    pushl   %esi

    # Timer interrupt
    movl    $Interrupt_0x20,%edx
    movw    $0x8e00,%dx
    movl    $0x00080000,    %eax
    movw    $Interrupt_0x20,%ax
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

IDT_48:
    .word   (IDTEnd - IDT) - 1
    .long   0x7e00 + IDT

    # Interrupt descriptor table
IDT:
    .fill   256, 8, 0
IDTEnd: