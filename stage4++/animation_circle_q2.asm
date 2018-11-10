Animation_Circle_Q2:
    push    bp
    mov     bp, sp
    sub     sp, 6
    push    es
    push    di
    push    si
    push    ax
    push    cx
    push    dx

    mov     si, word [bp + circ_r]      ; x = -r
    neg     si
    mov     [bp - x], si

    mov     [bp - y], word 0d           ; y = 0

    neg     si                          ; err = 2 - 2*r
    add     si, word [bp + circ_r]
    mov     [bp - err], word 2d
    sub     [bp - err], si

    mov     si, 0A000h                  ; Segment of display memory
    mov     es, si

Animation_Circle_Q2_Repeat:
    xor     cx, cx                      ; Delay
    mov     dx, 01000h
    mov     ah, 86h
    int 15h

    mov     si, word [bp + circ_ym]     ; 1st quadrant
    add     si, word [bp - y]
    mov     di, si
    shl     di, 8
    shl     si, 6
    add     di, si
    mov     si, word [bp + circ_xm]
    sub     si, word [bp - x]
    add     di, si
    mov     al, 00h                     ; Colour: black
    mov     byte [es:di], al

    mov     si, word [bp + circ_ym]     ; 2nd quadrant
    sub     si, word [bp - x]
    mov     di, si
    shl     di, 8
    shl     si, 6
    add     di, si
    mov     si, word [bp + circ_xm]
    sub     si, word [bp - y]
    add     di, si
    mov     al, 0Ch                     ; Colour: light red
    mov     byte [es:di], al

;____________________
    mov     si, word [bp - err]         ; r = err
    mov     [bp + circ_r], si

    mov     si, word [bp + circ_r]      ; if (r <= y) err += ++y*2+1;
    cmp     si, word [bp - y]
    jg      anim_circle_q2_test2
    inc     word [bp - y]
    mov     si, word [bp - y]
    add     si, si
    inc     si
    add     [bp - err], si

anim_circle_q2_test2:
    mov     si, word [bp + circ_r]      ; if (r > x || err > y) err += ++x*2+1;
    cmp     si, word [bp - x]
    jg      anim_circle_q2_test2_execute
    mov     si, word [bp - err]
    cmp     si, word [bp - y]
    jg      anim_circle_q2_test2_execute
    jmp     anim_circle_q2_test_exit

anim_circle_q2_test2_execute:
    inc     word [bp - x]               ; err += ++x*2+1
    mov     si, word [bp - x]
    add     si, si
    inc     si
    add     [bp - err], si

;____________________
anim_circle_q2_test_exit:
    cmp     [bp - x], word 0            ; if (x < 0) break;
    jl      Animation_Circle_Q2_Repeat

    pop     dx
    pop     cx
    pop     ax
    pop     si
    pop     di
    pop     es
    leave
    ret 6