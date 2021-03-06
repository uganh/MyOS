    .code16

BufPtr = 0x7e00
FATTab = 0x8000
LdrSeg = 0x1000

BS_jmpBoot:
    jmp     Boot
    nop

BS_OEMName:
    .ascii  "MyOSBoot"
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
    movw    %ax,    %es
    movw    $0,     %ax
    movw    %ax,    %ss
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

    # Load FAT
    movw    $1,     %ax
    movw    $FATTab,%bx
    movb    BPB_FATSz16,    %dl
    call    Read

    # Entry index
    movw    $0,     %di

FindLoader:
    cmpw    %di,    BPB_RootEntCnt
    jbe     NotFound
    testw   $0xf,   %di
    jnz     CompareFilename
    # Load next sector
    movw    %di,    %ax
    shrw    $4,     %ax
    addw    $19,    %ax
    movw    $BufPtr,%bx
    movb    $1,     %dl
    call    Read
    # Entry pointer
    movw    $BufPtr,%si
CompareFilename:
    # Test file
    testb   $0x20,  11(%si)
    jz      1f
    cld
    movw    $Target,%bx
    movw    $11,    %cx
0:
    lodsb
    cmpb    (%bx),  %al
    jnz     1f
    incw    %bx
    loop    0b
1:
    andw    $0xffe0,%si
    testw   %cx,    %cx
    jz      Found
    incw    %di
    addw    $0x20,  %si
    jmp     FindLoader

Found:
    movw    $0x1301,%ax
    movw    $Msg0,  %bp
    movw    Len0,   %cx
    movw    $0x0002,%bx
    movw    $0x0000,%dx
    int     $0x10

    # %si: Entry pointer
    # First cluster number
    movw    26(%si),%di

    # Loader sigment
    movw    $LdrSeg,%ax
    movw    %ax,    %es
    movw    $0,     %bx
0:
    cmpw    $0x0fff,%ax
    je      End
    movw    %di,    %ax
    addw    $31,    %ax
    movb    BPB_SecPerClus, %dl
    call    Read
    # Process bar
    movw    %bx,    %cx
    movb    $0x0e,  %ah
    movb    $0x2e,  %al
    movw    $0x0f,  %bx
    int     $0x10
    movw    %cx,    %bx
    # Next cluster
    movw    %di,    %si
    salw    $1,     %si
    addw    %di,    %si
    shrw    $1,     %si
    addw    $FATTab,%si
    movw    (%si),  %dx
    movw    %dx,    %ax
    andw    $0x0fff,%dx
    shrw    $4,     %ax
    testw   $1,     %di
    cmovz   %dx,    %ax
    movw    %ax,    %di
    addw    BPB_BytesPerSec,    %bx
    jmp     0b

NotFound:
    movw    $0x1301,%ax
    movw    $Msg1,  %bp
    movw    Len1,   %cx
    movw    $0x0002,%bx
    movw    $0x0000,%dx
    int     $0x10
    jmp     .

End:
    # Jump to loader
    ljmp    $LdrSeg,$0

Read:
    # Parameters
    #   %ax: The LBA number
    #   %dl: The number of sectors to be read
    #   [%es:%bx]: The buffer address
    # Return
    #   %ax: The total number of sectors successfully read
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

0:
    movb    $0x02,  %ah
    int     $0x13
    jc      0b
    
    popw    %bp
    ret

    # Read-only data
Target:
    .ascii  "LOADER     "

Msg0:
    .ascii  "Loading "
Len0:
    .word   . - Msg0
Msg1:
    .ascii  "ERROR: Loader not found"
Len1:
    .word   . - Msg1

    # Padding
    .org    510

    .word   0xaa55
