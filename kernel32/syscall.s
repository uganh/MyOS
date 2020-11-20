    .global Syscall_table
    .global Sys_print

Syscall_table:
    .long   Sys_delay
    .long   Sys_print

Sys_delay:
    movl    %ebx,   Delay_count

1:
    cmpl    $0,     Delay_count
    jg      1b

    ret

Sys_print:
    # Print string
    #
    # Parameters
    #   %ebx: String pointer
    #   %ecx: Length of string

    # TODO: Task segment
    movw    $0x0f,  %ax
    movw    %ax,    %ds

    pushl   %esi
    pushl   %edi
    pushl   %eax

    movl    %ebx,   %esi
    xorl    %edi,   %edi
    movb    $0x2,   %al
    cld

0:
    movsb
    stosb
    loop    0b

    popl    %eax
    popl    %edi
    popl    %esi
    ret
