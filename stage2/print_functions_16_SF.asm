; Common functions for writing to the console using BIOS interrupts.
;
; Input:
; [bp + 4] -- a null-terminated string

Console_Write_16:
    push    bp
    mov     bp, sp
    push    si
    push    ax
    mov     si, [bp + 4]                ; SI: beginning of the string.
    mov     ah, 0Eh                     ; Output character instruction.

Console_Write_16_Repeat:
    mov     al, [si]                    ; Assign value from SI memory address.
    inc     si                          ; si++
    test    al, al                      ; if (AL == 0) break;
    je      Console_Write_16_Done
    int     10h                         ; Output the current character.
    jmp     Console_Write_16_Repeat

Console_Write_16_Done:
    pop     ax
    pop     si
    leave
    ret 2

New_Line_16:                            ; Move cursor to the beginning of a new line.
    push    ax
    mov     ax, 0E0Dh
    int     10h
    mov     al, 0Ah
    int     10h
    pop     ax
    ret

Console_WriteLine_16:
    push    bp
    mov     bp, sp
    push    word [bp + 4]
    call    Console_Write_16
    call    New_Line_16
    leave
    ret 2