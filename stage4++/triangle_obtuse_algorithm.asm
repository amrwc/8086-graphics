; Input:
; peak_x: [bp + 8] -> [bp + triangle_x]
; peak_y: [bp + 6] -> [bp + triangle_y]
; height: [bp + 4] -> [bp + triangle_h]

Triangle_Obtuse_Algorithm:
    push    bp
    mov     bp, sp
    sub     sp, 4
    push    es
    push    di
    push    ax
    push    cx
    push    si

;____________________
; Setup
    mov     si, 0A000h                  ; Segment of display memory
    mov     es, si

; Offset on screen: di = 320*y + x -> di = 256*y + 64*y + x
    mov     di, [bp + triangle_y]
    shl     di, 8                       ; di *= 2**8 -> di *= 256
    mov     si, [bp + triangle_y]
    shl     si, 6                       ; si *= 2**6 -> si *= 64
    add     di, si                      ; di = 256y + 64y
    add     di, [bp + triangle_x]       ; di += x

    mov     [bp - tri_line_ln], word 1d ; Peak's length
    mov     [bp - tri_line_st], word 318d
    xor     si, si                      ; Loop index
    mov     al, 0Ch                     ; Colour
    cld                                 ; Clear direction flag -- stos increments CX by 1

;____________________
Triangle_Obtuse_Repeat:
    mov     cx, [bp - tri_line_ln]
    rep     stosb

    sub     [bp - tri_line_st], word 2d ; Next row

    add     di, [bp - tri_line_st]

    add     [bp - tri_line_ln], word 2d ; Increase the line's length

    inc     si
    cmp     si, word [bp + triangle_h]
    jl      Triangle_Obtuse_Repeat

;____________________
    pop     si
    pop     cx
    pop     ax
    pop     di
    pop     es
    leave
    ret 6