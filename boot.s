    .code16

BS_jmpBoot:
    jmp     Boot
    nop

BS_OEMName:
    .ascii  "MINEBoot"
BPB_BytesPerSec:
    .word   512
BPB_SecPerClus:
    .byte   1
BPB_RsvdSecCnt:
    .word   1
BPB_NumFATs:
    .byte   2
BPB_RootEntCnt:
    .word   224
BPB_TotSec16:
    .word   2880
BPB_Media:
    .byte   0xF0
BPB_FATSz16:
    .word   9
BPB_SecPerTrk:
    .word   18
BPB_NumHeads:
    .word   2
BPB_HiddSec:
    .int    0
BPB_TotSec32:
    .int    0
BS_DrvNum:
    .byte   0x80
BS_Reserved1:
    .byte   0
BS_BootSig:
    .byte   0x29
BS_VolID:
    .int    0
BS_VolLab:
    .ascii  "boot loader"
BS_FileSysType:
    .ascii  "FAT12   "

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
    movw    $Msg,   %bp
    movw    Len,    %cx
    movb    $0x02,  %bl
    movw    $0,     %dx
    movb    $0,     %dl
    int     $0x10

    # Reset disk
    movb    $0,     %ah
    movb    $0,     %dl
    int     $0x13

    # Loop
    jmp     .

    # Data
Msg:
    .ascii  "Hello, world."

Len:
    .word   . - Msg

    # Padding
    .org    510

    .word   0xaa55
