    .code16

FirstRootSector = 19

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
    .byte   0
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
    movw    %ax,    %ss
    movw    %ax,    %es

    # Stack
    movw    $0x7c00,%sp

    # Clear screan
    movw    $0x0600,%ax
    movw    $0x0700,%bx
    movw    $0,     %cx
    movw    $0x184f,%dx
    int     $0x10

    # Set focus
    movw    $0x0200,%ax
    movw    $0,     %dx
    movw    $0,     %bx
    int     $0x10

    # Entry index
    movw    $0,     %di

SearchBegin:
    cmpw    %di,    BPB_RootEntCnt
    jbe     SearchEnd
    testw   $0xf,   %di
    jnz     0f
    # Load next sector
    movw    %di,    %ax
    shrw    $4,     %ax
    addw    $FirstRootSector,   %ax
    movw    $0x8000,%bx
    movb    $1,     %dl
    call    ReadSectors
0:
    # Entry offset
    movw    %di,    %si
    andw    $0xf,   %si
    salw    $5,     %si
    addw    $0x8000,%si
    # File property
    testb   $0x30,  11(%si)
    jz      1f
    pushw   %bp
    movw    $0x1301,%ax
    movw    %si,    %bp
    movw    $8,     %cx
    movw    $0x0002,%bx
    movb    Row,    %dh
    movb    $0,     %dl
    incb    Row
    int     $0x10
    popw    %bp
1:
    incw    %di
    jmp     SearchBegin
SearchEnd:

    # Display
    movw    $0x1301,%ax
    movw    $Msg,   %bp
    movw    Len,    %cx
    movw    $0x0002,%bx
    movb    Row,    %dh
    movb    $0,     %dl
    int     $0x10

    # Reset floppy disk
    movb    $0,     %ah
    movb    BS_DrvNum,  %dl
    int     $0x13

    # Loop
    jmp     .

ReadSectors:
    # Parameter
    #   %ax: The LBA number
    #   %dl: The number of sectors to read
    #   [%es:%bx]: The buffer address
    # Return
    #   %ax: The number of sectors have been read
    pushw   %bp
    movw    %sp,    %bp

    divb    BPB_SecPerTrk
    # Head
    movb    %al,    %dh
    andb    $1,     %dh
    # Cylinder
    movb    %al,    %ch
    shrb    $1,     %ch
    # Sector
    movb    %ah,    %cl
    incb    %cl

    movb    %dl,    %al
    movb    BS_DrvNum,  %dl

Retry:
    movb    $0x02,  %ah
    int     $0x13
    jc      Retry
    
    popw    %bp
    ret

    # Data
Msg:
    .ascii  "Done."

Len:
    .word   . - Msg

End:
    .ascii  "\n"

Row:
    .byte   0

Index:
    .word   0

    # Padding
    .org    510

    .word   0xaa55
