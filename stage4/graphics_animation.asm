%assign anim_x0  10
%assign anim_y0  8
%assign anim_len 6
%assign px_set   4

Graphics_Animation:
    push    word 100d                   ; Parameters
    push    word 100d
    push    word 100d
    push    word 0C0Fh

    call    Graphics_Set_Display_Mode
    call    Graphics_Animation_Algorithm
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
    mov     dx, 01FFFh
    mov     ah, 86h
    int 15h

    dec     word [bp + anim_len]
    cmp     [bp + anim_len], word 0
    jge     Animation_Repeat

;____________________
; Return
    pop     dx
    pop     cx
    pop     ax
    pop     si
    pop     di
    pop     es
    leave
    ret 8