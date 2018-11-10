Console_Write_16_Graphics:
    push 	bp
	mov		bp, sp
	push	si
	push	ax
	mov		si, [bp + 4]                ; SI: beginning of the string.
    mov     ah, 9d                      ; Output character instruction.
    xor     bh, bh
    mov     bl, 0Fh                     ; Colour
    mov     cx, 1d

Console_Write_16_Graphics_Repeat:
    call    Console_Write_16_Graphics_Gotoxy
    inc     byte [bp + 8]
    mov     al, [si]                    ; Assign value from SI memory address.
    inc     si                          ; si++
    inc     dx                          ; Increase column
    test    al, al                      ; if (AL == 0) break;
    je      Console_Write_16_Graphics_Done
    int     10h                         ; Output the current character.
    jmp     Console_Write_16_Graphics_Repeat

Console_Write_16_Graphics_Done:
    pop		ax
	pop		si
	leave
    ret		6

Console_Write_16_Graphics_Gotoxy:
    push    ax
    push    bx
    push    dx

    mov     ah, 2d                      ; Set cursor position instruction
    mov     bh, 0                       ; Page number
    mov     dl, byte [bp + 8]           ; X0
    mov     dh, byte [bp + 6]           ; Y0
    int     10h

    pop     dx
    pop     bx
    pop     ax
    ret