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
; Offset on screen:
; es = A000h
; di = 320*y + x   ->   di = 256*y + 64*y + x
;
; Input:
; xm: [bp + 10] -> [bp + circ_xm]
; ym: [bp + 8]  -> [bp + circ_ym]
;  r: [bp + 6]  -> [bp + circ_r]
; px: [bp + 4]  -> [bp + px_set]

%assign circ_xm 10
%assign circ_ym 8
%assign circ_r  6
%assign px_set  4

%assign x   2
%assign y   4
%assign err 6

%include "graphics_circle_tests.asm"

Graphics_Circle_Algorithm:
    push    bp
    mov     bp, sp
    sub     sp, 6
    push    es
    push    di
    push    si
    push    ax
    push    cx
    push    dx

;____________________
; Setup
    call    Graphics_Circle_Tests

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
    mov     cx, word 1d                 ; Set stosb counter to 1
    mov     ax, word [bp + px_set]      ; Set colour

;____________________
Draw_Circle_Repeat:
    mov     si, word [bp + circ_ym] ;y  ; 1st quadrant
    add     si, word [bp - y]
    mov     di, si
    shl     di, 8                       ; di *= 2**8 -> di *= 256
    shl     si, 6                       ; si *= 2**6 -> si *= 64
    add     di, si                      ; di = 256y + 64y
    mov     si, word [bp + circ_xm] ;x
    sub     si, word [bp - x]
    add     di, si                      ; di += x
    stosb

    mov     si, word [bp + circ_ym]     ; 2nd quadrant
    sub     si, word [bp - x]
    mov     di, si
    shl     di, 8
    shl     si, 6
    add     di, si
    mov     si, word [bp + circ_xm]
    sub     si, word [bp - y]
    add     di, si
    stosb

    mov     si, word [bp + circ_ym]     ; 3rd quadrant
    sub     si, word [bp - y]
    mov     di, si
    shl     di, 8
    shl     si, 6
    add     di, si
    mov     si, word [bp + circ_xm]
    add     si, word [bp - x]
    add     di, si
    stosb

    mov     si, word [bp + circ_ym]     ; 4th quadrant
    add     si, word [bp - x]
    mov     di, si
    shl     di, 8
    shl     si, 6
    add     di, si
    mov     si, word [bp + circ_xm]
    add     si, word [bp - y]
    add     di, si
    stosb

;____________________
    mov     si, word [bp - err]         ; r = err
    mov     [bp + circ_r], si

    mov     si, word [bp + circ_r]      ; if (r <= y) err += ++y*2+1;
    cmp     si, word [bp - y]
    jg      circle_test2
    inc     word [bp - y]
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
    inc     word [bp - x]               ; err += ++x*2+1
    mov     si, word [bp - x]
    add     si, si
    inc     si
    add     [bp - err], si

;____________________
circle_test_exit:
    cmp     [bp - x], word 0            ; if (x < 0) break;
    jl      Draw_Circle_Repeat

    pop     dx
    pop     cx
    pop     ax
    pop     si
    pop     di
    pop     es
    leave
    ret 8