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

    movl    MsgLen, %eax
    pushl   %eax
    pushl   $MsgStr
    call    Print

    jmp     .

Print:
    # Parameters
    #   -0x4(%ebp): String pointer
    #   -0x8(%ebp): Length of string
    pushl   %ebp
    movl    %esp,   %ebp
    pushl   %esi
    pushl   %edi

    movl    0x8(%ebp),  %esi
    movl    0xc(%ebp),  %ecx
    xorl    %edi,   %edi
    movb    $0x2,   %al
    cld

0:
    movsb
    stosb
    loop    0b

    popl    %edi
    popl    %esi
    popl    %ebp
    ret

MsgStr:
    .ascii  "Kernel start"
MsgLen:
    .long   . - MsgStr
