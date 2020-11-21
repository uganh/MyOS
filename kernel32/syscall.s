    .global Syscall_table
    .global Sys_print

Syscall_table:
    .long   Sys_delay
    .long   Sys_print
    .long   Sys_getid

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

    pushl   %ebp
    movl    %esp,   %ebp
    pushl   %esi
    pushl   %edi
    pushl   %eax

    # TODO: How to access task segment?
    movw    10(%ebp),   %ax
    movw    %ax,    %ds

    movl    %ebx,   %esi
    xorl    %edi,   %edi
    movb    $0x2,   %al
    cld
0:
    movsb
    stosb
    loop    0b

    # TODO:
    movw    $0x10,  %ax
    movw    %ax,    %ds

    popl    %eax
    popl    %edi
    popl    %esi
    popl    %ebp
    ret

Sys_getid:
    # Get task id
    #
    # Return
    #   %eax: Task id

    movl    Task_id,%eax
    ret
