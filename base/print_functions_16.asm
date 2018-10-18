; Common functions for writing to the console using BIOS.
; Input: SI points to a null-terminated string.
Console_Write_16:                       ; Setup
    mov     ah, 0Eh                     ; Assign instruction to AH.

Console_Write_16_Repeat:
    mov     al, [si]                    ; Assign value from SI memory address.
    inc     si                          ; si++
    test    al, al                      ; If the AL byte is 0...
    jz      Console_Write_16_Done       ; ...the loop should end.
    int     10h                         ; Output character to screen.
    jmp     Console_Write_16_Repeat

Console_Write_16_Done:
    ret

New_Line_16:                            ; Move cursor to the beginning of a new line.
    mov     ax, 0E0Dh
    int     10h
    mov     al, 0Ah
    int     10h

    ret

Console_WriteLine_16:
    call    Console_Write_16
    call    New_Line_16

    ret