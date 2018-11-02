; Circle drawing implementation of Bresenham's line drawing algorithm.
;
; void plotCircle(int xm, int ym, int r)
; {
;   int x = -r, y = 0, err = 2-2*r;         /* II. Quadrant */ 
;   do {
;     setPixel(xm-x, ym+y);                 /*   I. Quadrant */
;     setPixel(xm-y, ym-x);                 /*  II. Quadrant */
;     setPixel(xm+x, ym-y);                 /* III. Quadrant */
;     setPixel(xm+y, ym+x);                 /*  IV. Quadrant */
;     r = err;
;     if (r <= y) err += ++y*2+1;           /* e_xy+e_y < 0 */
;     if (r > x || err > y) err += ++x*2+1; /* e_xy+e_x > 0 or no 2nd y-step */
;   } while (x < 0);
; }
;
; Input:
; xm: [bp + 10] -> [bp + circ_xm]
; ym: [bp + 8]  -> [bp + circ_ym]
;  r: [bp + 6]  -> [bp + circ_r]
; px: [bp + 4]  -> [bp + px_set]

%assign x   2
%assign y   4
%assign err 6

Graphics_Circle_Algorithm:
    push    bp
    mov     bp, sp
    sub     sp, 6
    push    cx
    push    dx
    push    si

    mov     si, word [bp + circ_r]      ; if (r < 0) r = -r;
    cmp     si, word 0d
    jge     circle_setup
    neg     si
    mov     [bp + circ_r], si

circle_setup:
    mov     si, word [bp + circ_r]      ; x = -r
    neg     si
    mov     [bp - x], si

    mov     [bp - y], word 0d           ; y = 0

    neg     si                          ; err = 2 - 2*r
    add     si, word [bp + circ_r]
    mov     [bp - err], word 2d
    sub     [bp - err], si

    mov     ax, word [bp + px_set]

Draw_Circle_Repeat:
    mov     cx, word [bp + circ_xm]     ; 1st quadrant
    sub     cx, word [bp - x]
    mov     dx, word [bp + circ_ym]
    add     dx, word [bp - y]
    int     10h

    mov     cx, word [bp + circ_xm]     ; 2nd quadrant
    sub     cx, word [bp - y]
    mov     dx, word [bp + circ_ym]
    sub     dx, word [bp - x]
    int     10h

    mov     cx, word [bp + circ_xm]     ; 3rd quadrant
    add     cx, word [bp - x]
    mov     dx, word [bp + circ_ym]
    sub     dx, word [bp - y]
    int     10h

    mov     cx, word [bp + circ_xm]     ; 4th quadrant
    add     cx, word [bp - y]
    mov     dx, word [bp + circ_ym]
    add     dx, word [bp - x]
    int     10h

    mov     si, word [bp - err]         ; r = err
    mov     [bp + circ_r], si

    mov     si, word [bp + circ_r]      ; if (r <= y) err += ++y*2+1;
    cmp     si, word [bp - y]
    jg      circle_test2
    add     [bp - y], word 1d
    mov     si, word [bp - y]
    add     si, si
    inc     si
    add     [bp - err], si

circle_test2:
    mov     si, word [bp + circ_r]      ; if (r > x || err > y) err += ++x*2+1;
    cmp     si, word [bp - x]
    jg      circle_test2_execute
    mov     si, word [bp - err]
    cmp     si, word [bp - y]
    jg      circle_test2_execute
    jmp     circle_test_exit

circle_test2_execute:
    add     [bp - x], word 1d
    mov     si, word [bp - x]           ; err += ++x*2+1
    add     si, si
    inc     si
    add     [bp - err], si

circle_test_exit:
    mov     si, [bp - x]                ; if (x < 0) break;
    cmp     si, word 0d
    jl      Draw_Circle_Repeat

    pop     si
    pop     dx
    pop     cx
    leave
    ret 8