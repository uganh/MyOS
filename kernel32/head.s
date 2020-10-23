Kernel:
    # Set segment
    movw    $0x10,  %ax
    movw    %ax,    %ds
    movw    $0x18,  %ax
    movw    %ax,    %ss
    movw    $0x20,  %ax
    movw    %ax,    %es

    # Set stack
    movw    $512,   %esp

    pushl   $MsgStr
    pushl   MsgLen
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

    movl    -0x4(%ebp), %esi
    movl    -0x8(%ebp), %ecx
    xorl    %edi,   %edi    

0:
    cld
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
