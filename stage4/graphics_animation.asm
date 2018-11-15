%assign anim_x0  10
%assign anim_y0  8
%assign anim_len 6
%assign px_set   4

Graphics_Animation:
    call    Graphics_Set_Display_Mode

    push    word 58d   ; x0             ; Line's parameters
    push    word 100d  ; y0
    push    word 200d  ; length
    push    word 0C0Fh ; colour
    call    Graphics_Animation_Algorithm

    push    word check_stage_4_plus
    call    Console_Write_16_Graphics

    call    Graphics_Done
    ret

Graphics_Animation_Algorithm:
    push    bp
    mov     bp, sp
    push    es
    push    di
    push    si
    push    ax
    push    cx
    push    dx

    mov     si, 0A000h                  ; Segment of display memory
    mov     es, si

; Offset on screen: di = 320*y + x -> di = 256*y + 64*y + x
    mov     di, [bp + anim_y0]
    shl     di, 8                       ; di *= 2**8 -> di *= 256
    mov     si, [bp + anim_y0]
    shl     si, 6                       ; si *= 2**6 -> si *= 64
    add     di, si                      ; di = 256y + 64y
    add     di, [bp + anim_x0]          ; di += x

    mov     ax, [bp + px_set]           ; Colour
    cld                                 ; Clear direction flag -- stos increments CX by 1

Animation_Repeat:
    stosb

    xor     cx, cx                      ; Delay
    mov     dx, 01000h
    mov     ah, 86h
    int 15h

    dec     word [bp + anim_len]
    cmp     [bp + anim_len], word 0
    jge     Animation_Repeat

    pop     dx
    pop     cx
    pop     ax
    pop     si
    pop     di
    pop     es
    leave
    ret 8

;____________________
Console_Write_16_Graphics:
    push    bp
    mov	    bp, sp
    push    si
    push    ax
    mov	    si, [bp + 4]                ; SI: beginning of the string.
    mov     ah, 9d                      ; Output character instruction.
    xor     bh, bh
    mov     bl, 0Ch                     ; Colour
    mov     cx, 1d

    mov     [cursor_x], byte 7d
    mov     [cursor_y], byte 10d

Console_Write_16_Graphics_Repeat:
    call    Console_Write_16_Graphics_Gotoxy
    inc     byte [cursor_x]
    mov     al, [si]                    ; Assign value from SI memory address.
    inc     si                          ; si++
    inc     dx                          ; Increase column
    test    al, al                      ; if (AL == 0) break;
    je      Console_Write_16_Graphics_Done
    int     10h                         ; Output the current character.
    jmp     Console_Write_16_Graphics_Repeat

Console_Write_16_Graphics_Done:
    pop	    ax
    pop	    si
    leave
    ret 2

Console_Write_16_Graphics_Gotoxy:
    push    ax
    push    bx
    push    dx

    mov     ah, 2d                      ; Set cursor position instruction
    mov     bh, 0                       ; Page number
    mov     dl, byte [cursor_x]
    mov     dh, byte [cursor_y]
    int     10h
    
    pop     dx
    pop     bx
    pop     ax
    ret

cursor_x: db 0
cursor_y: db 0
check_stage_4_plus: db 'Please check out Stage 4++', 0