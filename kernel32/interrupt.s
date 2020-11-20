    .global Init_IDTR
    .global Delay_count

    # Interrupt descriptor table
IDT:
    .fill   256, 8, 0
IDTEnd:

IDT_48:
    .word   (IDTEnd - IDT) - 1
    .long   0x7e00 + IDT

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
    leal    IDT(,%ecx,8),   %esi
    movl    %eax,   (%esi)
    movl    %edx,   4(%esi)

    # Interrupt 0x21
    movl    $Keyboard_interrupt,%edx
    movw    $0x8e00,%dx
    movl    $0x00080000,    %eax
    movw    $Keyboard_interrupt,%ax
    movl    $0x21,  %ecx
    leal    IDT(,%ecx,8),   %esi
    movl    %eax,   (%esi)
    movl    %edx,   4(%esi)

    # Interrupt 0x80
    movl    $Syscall_interrupt, %edx
    movw    $0xef00,%dx
    movl    $0x00080000,    %eax
    movw    $Syscall_interrupt, %ax
    movl    $0x80,  %ecx
    leal    IDT(,%ecx,8),   %esi
    movl    %eax,   (%esi)
    movl    %edx,   4(%esi)

    lidt    IDT_48

    popl    %esi
    popl    %edx
    popl    %ecx
    popl    %eax
    ret

Timer_interrupt:
    # Timer interrupt handler

    pushw   %ds
    pushw   %es

    # Set segments
    pushl   %eax
    movw    $0x10,  %ax
    movw    %ax,    %ds
    movw    $0x18,  %ax
    movw    %ax,    %es
    popl    %eax

    call    Enable_8259A

    decl    Delay_count

    subl    $1,     Clock_count
    jne     1f

    movl    $100,   Clock_count
    # Switch task
    # Todo

1:
    popw    %es
    popw    %ds
    iret

Clock_count:
    .long   100

Delay_count:
    .long   0

Keyboard_interrupt:
    # Keyboard interrupt handler

    call    Enable_8259A
    call    Enable_keyboard

    movl    $Msg,   %ebx
    movl    MsgLen, %ecx
    call    Sys_print

    iret

Msg:
    .ascii  "233"
MsgLen:
    .long   . - Msg

Syscall_interrupt:
    # System call interrupt handler

    pushw   %ds
    pushw   %es

    pushl   %eax
    movw    $0x10,  %ax
    movw    %ax,    %ds
    movw    $0x18,  %ax
    movw    %ax,    %es
    popl    %eax

    call    *Syscall_table(,%eax,4)

    popw    %es
    popw    %ds
    iret
