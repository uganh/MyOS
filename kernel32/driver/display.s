    .global Display

Display:
    # Display string
    #
    # Parameters
    #   0x8(%ebp): String pointer
    #   0xc(%ebp): Length of string
    #   
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