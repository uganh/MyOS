    .global Init_IDTR
    .global Delay_count, Task_id

    # Interrupt descriptor table
IDT:
    .fill   256, 8, 0
IDTEnd:

IDT_48:
    .word   IDTEnd - IDT - 1
    .long   IDT

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
    pushw   %fs

    # Set segments
    pushl   %eax
    movw    %ds,    %ax
    movw    %ax,    %fs
    movw    $0x10,  %ax
    movw    %ax,    %ds
    movw    %ax,    %es
    popl    %eax

    call    Enable_8259A

    decl    Delay_count

    subl    $1,     Clock_count
    jne     2f

    movl    $1000,  Clock_count
    # Switch task
    cmpl    $1,     Task_id
    jne     1f
    movl    $2,     Task_id
    # This instruction changes TR and LDTR
    ljmp    $0x30,  $0
    # This is the next instruction when switch back to task 1
    jmp     2f
1:
    cmpl    $2,     Task_id
    jne     2f
    movl    $1,     Task_id
    ljmp    $0x20,  $0

2:
    popw    %fs
    popw    %es
    popw    %ds
    iret

Clock_count:
    .long   1000

Delay_count:
    .long   0

Task_id:
    .long   0

Keyboard_interrupt:
    # Keyboard interrupt handler

    pushw   %ds
    pushw   %es
    pushw   %fs

    pushl   %ebx
    pushl   %ecx

    # Set segments
    pushl   %eax
    movw    %ds,    %ax
    movw    %ax,    %fs
    movw    $0x10,  %ax
    movw    %ax,    %ds
    movw    %ax,    %es
    popl    %eax

    call    Enable_8259A
    call    Enable_keyboard

    movl    $Msg,   %ebx
    movl    MsgLen, %ecx
    call    Sys_print

    popl    %ecx
    popl    %ebx

    popw    %fs
    popw    %es
    popw    %ds
    iret

Msg:
    .ascii  "233"
MsgLen:
    .long   . - Msg

Syscall_interrupt:
    # System call interrupt handler

    pushw   %ds
    pushw   %es
    pushw   %fs

    # Set segments
    pushl   %eax
    movw    %ds,    %ax
    movw    %ax,    %fs
    movw    $0x10,  %ax
    movw    %ax,    %ds
    movw    %ax,    %es
    popl    %eax

    call    *Syscall_table(,%eax,4)

    popw    %fs
    popw    %es
    popw    %ds
    iret
