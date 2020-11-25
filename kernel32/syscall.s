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

    pushl   %edi
    pushl   %eax
    pushl   %ebx
    pushl   %ecx

    movl    $0xb8000,   %edi

1:
    movb    %fs:(%ebx), %al
    movb    %al,    (%edi)
    movb    $2,     1(%edi)
    incl    %ebx
    addl    $2,     %edi
    loop    1b

    popl    %ecx
    popl    %ebx
    popl    %eax
    popl    %edi
    ret

Sys_getid:
    # Get task id
    #
    # Return
    #   %eax: Task id

    movl    Task_id,%eax
    ret
