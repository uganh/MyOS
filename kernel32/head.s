    .code16

    # Enter the protected mode
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
    movw    %ax,    %es

    # Set stack
    movl    $Stack_end, %esp

    # Interrupt every 10 ms
    movw    $11931, %ax
    call    Init_8253

    call    Init_keyboard

    call    Init_8259A

    call    Init_IDTR

    # Setup paging
    xorl    %eax,   %eax
    movl    $0,     %edi
    movl    $4096,  %ecx
    cld
    rep
    stosl
    
    movl    %eax,   %cr3
    # Page directory
    movl    $0x1003,    0x0000
    movl    $0x2007,    0x0040
    movl    $0x3007,    0x0080
    # Kernel page
    movl    $0x7003,    0x1000 + 0x7 * 4
    movl    $0x8003,    0x1000 + 0x8 * 4
    movl    $0xb8003,   0x1000 + 0xb8 * 4
    # Task 1 page
    movl    $0xa007,    0x2000
    # Task 2 page
    movl    $0xb007,    0x3000

    # Enable paging
    movl    %cr0,   %eax
    xorl    $0x80000000,%eax
    movl    %eax,   %cr0

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

    # Global descriptor table
GDT:
    .quad   0
    .quad   0x00409a000000ffff
    .quad   0x00cf92000000ffff
    .quad   0x0040920b80000f9f  # Unused
    .word   0x0067, TSS1, 0x8900, 0x0000
    .word   0x000f, LDT1, 0x8200, 0x0000
    .word   0x0067, TSS2, 0x8900, 0x0000
    .word   0x000f, LDT2, 0x8200, 0x0000
GDT_end:

GDT_48:
    .word   GDT_end - GDT - 1
    .long   GDT

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
    .long   0x200               # Note: Must be set
    .long   0, 0, 0, 0
    .long   0x200, 0, 0, 0
    .long   0, 0x07, 0x0f, 0
    .long   0, 0
    .long   0x38
    .long   0
TSS2_end:

LDT1:
    .quad   0x0440fa00000001ff
    .quad   0x0440f200000001ff
LDT1_end:

LDT2:
    .quad   0x0840fa00000001ff
    .quad   0x0840f200000001ff
LDT2_end:

    # Task kernel stacks

Stack1:
    .fill   64, 4, 0
Stack1_end:

Stack2:
    .fill   64, 4, 0
Stack2_end:
