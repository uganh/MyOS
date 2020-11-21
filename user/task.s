    .global Task

Task:
    movw    $0x0f,  %ax
    movw    %ax,    %ds
    movw    %ax,    %es

    # Getid
    movl    $2,     %eax
    int     $0x80

    movl    $Format,%ebx
    addl    $0x30,  %eax
    movb    %eax,   5(%ebx)

    movb    $0x61,  %dl

1:
    cmpb    $0x68,  %dl
    jnz     2f
    movb    $0x61,  %dl
2:
    movb    %dl,    %al
    # TODO: Different segment with kernel
    movl    $Format_end,%ebx
    movb    %al,    -1(%ebx)

    # Print
    movl    $1,     %eax
    movl    $Format,%ebx
    movl    Length, %ecx
    int     $0x80

    # Delay
    movl    $0,     %eax
    movl    $100,   %ebx
    int     $0x80

    addb    $1,     %dl
    jmp     1b

Format:
    .ascii  "Task  :  "
Format_end:

Length:
    .long   Format_end - Format
