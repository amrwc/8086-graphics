%assign circ_xm 8 ; Circle
%assign circ_ym 6
%assign circ_r  4

%assign x   2
%assign y   4
%assign err 6

%include "animation_circle_q1.asm"
%include "animation_circle_q2.asm"
%include "animation_circle_q3.asm"
%include "animation_circle_q4.asm"
%include "animation_circle_finish.asm"

Graphics_Animation:
    call    Graphics_Set_Display_Mode

    push    word 130d  ; xm             ; Circle's parameters
    push    word 110d  ; ym
    push    word 50d   ; r
    call    Animation_Circle_Q4

    push    word 130d
    push    word 110d
    push    word 50d
    call    Animation_Circle_Q1

    push    word 130d
    push    word 110d
    push    word 50d
    call    Animation_Circle_Q2

    push    word 130d
    push    word 110d
    push    word 50d
    call    Animation_Circle_Q3

    push    word 130d
    push    word 110d
    push    word 50d
    call    Animation_Circle_Finish

    call    Graphics_Done

    ret

;____________________
Graphics_Animation_Circle:
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
;    mov     ax, word [bp + px_set]      ; Set colour

Graphics_Animation_Circle_Repeat:
    xor     cx, cx                      ; Delay
    mov     dx, 01000h
    mov     ah, 86h
    int 15h

    mov     si, word [bp + circ_ym] ;y  ; 1st quadrant
    add     si, word [bp - y]
    mov     di, si
    shl     di, 8                       ; di *= 2**8 -> di *= 256
    shl     si, 6                       ; si *= 2**6 -> si *= 64
    add     di, si                      ; di = 256y + 64y
    mov     si, word [bp + circ_xm] ;x
    sub     si, word [bp - x]
    add     di, si                      ; di += x
    mov     byte [es:di], al            ; Plot pixel to the calculated location.

    mov     si, word [bp + circ_ym]     ; 2nd quadrant
    sub     si, word [bp - x]
    mov     di, si
    shl     di, 8
    shl     si, 6
    add     di, si
    mov     si, word [bp + circ_xm]
    sub     si, word [bp - y]
    add     di, si
    mov     byte [es:di], al

    mov     si, word [bp + circ_ym]     ; 3rd quadrant
    sub     si, word [bp - y]
    mov     di, si
    shl     di, 8
    shl     si, 6
    add     di, si
    mov     si, word [bp + circ_xm]
    add     si, word [bp - x]
    add     di, si
    mov     byte [es:di], al

    mov     si, word [bp + circ_ym]     ; 4th quadrant
    add     si, word [bp - x]
    mov     di, si
    shl     di, 8
    shl     si, 6
    add     di, si
    mov     si, word [bp + circ_xm]
    add     si, word [bp - y]
    add     di, si
    mov     byte [es:di], al

;____________________
    mov     si, word [bp - err]         ; r = err
    mov     [bp + circ_r], si

    mov     si, word [bp + circ_r]      ; if (r <= y) err += ++y*2+1;
    cmp     si, word [bp - y]
    jg      anim_circle_test2
    inc     word [bp - y]
    mov     si, word [bp - y]
    add     si, si
    inc     si
    add     [bp - err], si

anim_circle_test2:
    mov     si, word [bp + circ_r]      ; if (r > x || err > y) err += ++x*2+1;
    cmp     si, word [bp - x]
    jg      anim_circle_test2_execute
    mov     si, word [bp - err]
    cmp     si, word [bp - y]
    jg      anim_circle_test2_execute
    jmp     anim_circle_test_exit

anim_circle_test2_execute:
    inc     word [bp - x]               ; err += ++x*2+1
    mov     si, word [bp - x]
    add     si, si
    inc     si
    add     [bp - err], si

;____________________
anim_circle_test_exit:
    cmp     [bp - x], word 0            ; if (x < 0) break;
    jl      Graphics_Animation_Circle_Repeat

    pop     dx
    pop     cx
    pop     ax
    pop     si
    pop     di
    pop     es
    leave
    ret 8