BITS 16

; Tell the assembler that we will be loaded at 7C00 (That's where the BIOS loads boot loader code).
ORG 7C00h
start:
    jmp     Real_Mode_Start

%include "print_functions_16.asm"

Real_Mode_Start:
    cli
    xor     ax, ax                      ; Set stack segment (SS) to 0 and set stack size to top of segment.
    mov     ss, ax
    mov     sp, 0FFFFh

    mov     ds, ax                      ; Set data segment registers (DS and ES) to 0.
    mov     es, ax

    mov     [boot_device], dl           ; Boot device number is passed in DL

    mov     ax, 0003h                   ; Clear screen.
    int     10h

    mov     si, boot_message            ; Display the greeting.
    call    Console_WriteLine_16

    mov     ah, 2                       ; BIOS Read sector functions_16
    mov     al, 7                       ; Number of sectors to read = 7
    mov     bx, 9000h                   ; The 7 sectors will be loaded into memory at ES:BX (0000:9000h)
    mov     ch, 0                       ; Use cylinder 0
    mov     dh, 0                       ; Use head 0
    mov     dl, [boot_device]
    mov     cl, 2                       ; Start reading at sector 2 (i.e. one after the boot sector)
    int     13h
    cmp     al, 7                       ; AL returns the number of sectors read.  If this is not 7, report an error
    jne     Read_Failed

    mov     dl, [boot_device]           ; Pass boot device to second stage
    jmp     9000h                       ; Jump to stage 2

;____________________
Read_Failed:
    mov     si, read_failed_msg
    call    Console_WriteLine_16

Quit_Boot:
    mov     si, cannot_continue         ; Display 'Cannot continue' message
    call    Console_WriteLine_16

    hlt

;____________________
; Data
boot_device db 0
boot_message: db 'UODos V1.0', 0
read_failed_msg: db 'Unable to read stage 2 of the boot process', 0
cannot_continue: db 'Cannot continue boot process', 0

; Pad out the boot loader so that it will be exactly 512 bytes.
    times 510 - ($ - $$) db 0

; The segment must end with AA55h to indicate that it is a boot sector.
    dw 0AA55h