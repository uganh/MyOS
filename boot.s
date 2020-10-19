    .code16

Boot:
    movw    %cs,    %ax
    movw    %ax,    %ds
    movw    %ax,    %es

    # Clear screan
    movw    $0x0600,%ax
    movw    $0,     %cx
    movw    $0x184f,%dx
    int     $0x10

    # Set focus
    movb    $0x02,  %ah
    movw    $0,     %dx
    movw    $0,     %bx
    int     $0x10

    # Display
    movb    $0x13,  %ah
    movb    $0x01,  %al
    movw    $msg,   %bp
    movw    len,    %cx
    movb    $0x02,  %bl
    movb    $0,     %dh
    movb    $0,     %dl
    int     $0x10

    # Loop
    jmp     .

    # Data
msg:
    .ascii  "Hello, world."

len:
    .word   . - msg

    # Padding
    . = Boot + 0x1fe

    .word   0xaa55
