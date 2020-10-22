    .code16

Loader:
    movw    %cs,    %ax
    movw    %ax,    %ds
    movw    %ax,    %es
    movw    $0,     %ax
    movw    %ax,    %ss
    movw    $0x7c00,%sp

    # Display
    movw    $0x1301,%ax
    movw    $Msg0,  %bp
    movw    Len0,   %cx
    movw    $0x0002,%bx
    movw    $0x0100,%dx
    int     $0x10

    jmp     .

    # Read-only data
Msg0:
    .ascii  "Loader start"
Len0:
    .word   . - Msg0
