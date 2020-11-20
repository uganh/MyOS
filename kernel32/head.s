    .code16

    # Enter the protected mode
    movw    %cs,    %ax
    movw    %ax,    %ds

    lgdt    GDT_48
    
    movw    $1,     %ax
    lmsw    %ax

    ljmp    $0x8,   $Kernel

    .code32

Kernel:
    # Set segments
    movw    $0x10,  %ax
    movw    %ax,    %ds
    movw    %ax,    %ss
    movw    $0x18,  %ax
    movw    %ax,    %es

    # Set stack
    movl    $Stack_end, %esp

    # movl    $Msg,   %ebx
    # movl    MsgLen, %ecx
    # call    Sys_print

    call    Init_8259A

    # Interrupt every 10 ms
    movw    $11931, %ax
    call    Init_8253

    call    Init_keyboard

    movw    $0xfffc,%ax
    call    Mask_8259A

    call    Init_IDTR
    sti

    # Initialize task
    movl    $1,     Task_id
    movw    $0x20,  %ax
    ltr     %ax
    movw    $0x28,  %ax
    lldt    %ax

    # Move to user
    pushl   $0x0f
    pushl   $0x200
    pushf
    pushl   $0x07
    pushl   $0
    iret

    # jmp     .

    # Global descriptor table
GDT:
    .quad   0
    .quad   0x00409a007e001fff
    .quad   0x004092007e001fff
    .quad   0x0040920b80000f9f
    .word   0x0067, 0x7e00 + TSS1, 0x8900, 0x0000
    .word   0x000f, 0x7e00 + LDT1, 0x8200, 0x0000
    .word   0x0067, 0x7e00 + TSS2, 0x8900, 0x0000
    .word   0x000f, 0x7e00 + LDT2, 0x8200, 0x0000
GDT_end:

GDT_48:
    .word   GDT_end - GDT - 1
    .long   0x7e00 + GDT

Stack:
    .fill   64, 4, 0
Stack_end:

TSS1:
    .long   0
    .long   Stack1_end, 0x10    # esp0; 0x0000, ss0
    .long   0, 0, 0, 0
    .long   0                   # cr3
    .long   0                   # eip
    .long   0                   # eflags
    .long   0, 0, 0, 0          # eax; ecx; edx; ebx
    .long   0, 0, 0, 0          # esp; ebp; esi; edi
    .long   0, 0, 0, 0          # 0x0000, es; 0x0000, cs; 0x0000, ss; 0x0000, ds
    .long   0, 0                # 0x0000, fs; 0x0000, gs
    .long   0x28                # 0x0000, LDT selector
    .long   0
TSS1_end:

TSS2:
    .long   0
    .long   Stack2_end, 0x10
    .long   0, 0, 0, 0
    .long   0
    .long   0
    .long   0
    .long   0, 0, 0, 0
    .long   0, 0, 0, 0
    .long   0, 0, 0, 0
    .long   0, 0
    .long   0x38
    .long   0
TSS2_end:

    # Note: User code is linked with kernel now!!!
LDT1:
    .word   0x01ff, 0x9c00, 0xfa00, 0x0040
    .word   0x01ff, 0x9c00, 0xf200, 0x0040
LDT1_end:

LDT2:
LDT2_end:

    # Task kernel stacks

Stack1:
    .fill   64, 4, 0
Stack1_end:

Stack2:
    .fill   64, 4, 0
Stack2_end:

    # Read-only data
Msg:
    .ascii  "Kernel start"
MsgLen:
    .long   . - Msg

Task_id:
    .long   0
