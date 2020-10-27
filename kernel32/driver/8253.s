    .global Init_8253, Interrupt_0x20

    # Frequency: 1193180Hz
    # Registers: 0x43, 0x40
    # Interrupt: 0x20

Init_8253:
    # Initialize programmable timer (0)
    #
    # Parameters
    #   0x8(%ebp): Latch

    pushl   %ebp
    movl    %esp,   %ebp
    pushl   %eax

    movb    $0x36,  %al
    outb    %al,    $0x43

    movl    8(%ebp),%eax
    outb    %al,    $0x40
    movb    %ah,    %al
    outb    %al,    $0x40

    popl    %eax
    popl    %ebp
    ret

Interrupt_0x20:
    # Interrupt handler
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

    # Global data
Milsec:
    .long   1000
Status:
    .long   0

    # Read-only data
Msg0:
    .ascii  "Foo"
MsgLen0:
    .long   . - Msg0
Msg1:
    .ascii  "Bar"
MsgLen1:
    .long   . - Msg1
