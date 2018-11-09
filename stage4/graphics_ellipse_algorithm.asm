; The following algorithm draws an ellipse inside a specified rectangle.
;
; This solution is limited by 16 bit address space. Every multiplication
; being made inside of the algorithm, stores the result in DX:AX registers.
; Therefore, it is not possible to later multiply DX:AX again with
; the current solution. This results in a horrible errors while drawing
; the ellipse. The option 1 shows the right output. Option 2 shows
; an example of an erroneuos output. 
;
;void plotEllipseRect(int x0, int y0, int x1, int y1)
;{
;   int a = abs(x1-x0), b = abs(y1-y0), b1 = b&1; /* values of diameter */
;   long dx = 4*(1-a)*b*b, dy = 4*(b1+1)*a*a; /* error increment */
;   long err = dx+dy+b1*a*a, e2; /* error of 1.step */
;
;   if (x0 > x1) { x0 = x1; x1 += a; } /* if called with swapped points */
;   if (y0 > y1) y0 = y1; /* .. exchange them */
;   y0 += (b+1)/2; y1 = y0-b1;   /* starting pixel */
;   a *= 8*a; b1 = 8*b*b;
;
;   do {
;       setPixel(x1, y0); /*   I. Quadrant */
;       setPixel(x0, y0); /*  II. Quadrant */
;       setPixel(x0, y1); /* III. Quadrant */
;       setPixel(x1, y1); /*  IV. Quadrant */
;       e2 = 2*err;
;       if (e2 <= dy) { y0++; y1--; err += dy += a; }  /* y step */ 
;       if (e2 >= dx || 2*err > dy) { x0++; x1--; err += dx += b1; } /* x step */
;   } while (x0 <= x1);
;
;   while (y0-y1 < b) {  /* too early stop of flat ellipses a=1 */
;       setPixel(x0-1, y0); /* -> finish tip of ellipse */
;       setPixel(x1+1, y0++); 
;       setPixel(x0-1, y1);
;       setPixel(x1+1, y1--); 
;   }
;}
;
; Offset on screen:
; es = A000h
; di = 320*y + x   ->   di = 256*y + 64*y + x
;
; Input:
; x0: [bp + 12] -> [bp + ellipse_x0]
; y0: [bp + 10] -> [bp + ellipse_y0]
; x1: [bp + 8]  -> [bp + ellipse_x1]
; y1: [bp + 6]  -> [bp + ellipse_y1]
; px: [bp + 4]  -> [bp + px_set]

%assign ellipse_x0 12
%assign ellipse_y0 10
%assign ellipse_x1 8
%assign ellipse_y1 6
%assign px_set     4

%assign a       2
%assign b       4
%assign b1      6
%assign delta_x 8
%assign delta_y 10
%assign err     12
%assign e2      14

;%include "graphics_ellipse_tests.asm" ; CREATE TESTS

Graphics_Ellipse_Algorithm:
    push    bp
    mov     bp, sp
    sub     sp, 14
    push    es
    push    di
    push    si
    push    ax
    push    cx
    push    dx

;____________________
; Setup
    ;call    Graphics_Ellipse_Tests

    mov     ax, word [bp + ellipse_x1]  ; a = abs(x1 - x0)
    sub     ax, word [bp + ellipse_x0]
    cwd
    xor     ax, dx
    sub     ax, dx
    mov     [bp - a], ax

    mov     ax, word [bp + ellipse_y1]  ; b = abs(y1 - y0)
    sub     ax, word [bp + ellipse_y0]
    cwd
    xor     ax, dx
    sub     ax, dx
    mov     [bp - b], ax

    and     ax, 1                       ; b1 = b & 1
    mov     [bp - b1], ax

    mov     ax, word 1d                 ; dx = 4*(1-a)*b*b
    sub     ax, word [bp - a]
    shl     ax, 2
    mul     word [bp - b]
    mul     word [bp - b]
    mov     [bp - delta_x], ax ;dx:ax

    mov     ax, word 1d                 ; dy = 4*(b1+1)*a*a
    add     ax, word [bp - b1]
    shl     ax, 2
    mul     word [bp - a]
    mul     word [bp - a]
    mov     [bp - delta_y], ax ;dx:ax

    mov     ax, word [bp - b1]
    mul     word [bp - a]
    mul     word [bp - a]
    add     ax, word [bp - delta_x] ;dx:ax
    add     ax, word [bp - delta_y] ;dx:ax
    mov     [bp - err], ax ;dx:ax

    mov     si, word [bp + ellipse_x1]  ; if (x1 <= x0) skip;
    cmp     si, word [bp + ellipse_x0]
    jle     skip_swap_x
    mov     [bp + ellipse_x0], si       ; x0 = x1
    add     si, [bp - a]                ; x1 += a
    mov     [bp + ellipse_x1], si
skip_swap_x:

    mov     si, word [bp + ellipse_y1]  ; if (y1 <= y0) skip;
    cmp     si, word [bp + ellipse_y0]
    jle     skip_swap_y
    mov     [bp + ellipse_y0], si       ; y0 = y1
skip_swap_y:

    mov     si, word [bp - b]           ; y0 += (b+1)/2
    inc     si
    shr     si, 1
    add     [bp + ellipse_y0], si

    mov     si, word [bp + ellipse_y0]  ; y1 = y0-b1
    sub     si, word [bp - b1]
    mov     [bp + ellipse_y1], si

    mov     ax, word [bp - a]           ; a *= 8*a
    shl     ax, 3
    mul     word [bp - a]
    mov     [bp - a], ax ;dx:ax

    mov     ax, word [bp - b]           ; b1 = 8*b*b
    shl     ax, 3
    mul     word [bp - b]
    mov     [bp - b1], ax ;dx:ax

    mov     si, 0A000h                  ; Segment of display memory
    mov     es, si
    mov     cx, word 1d                 ; Set stosb counter to 1
    mov     ax, word [bp + px_set]      ; Set colour

;____________________
Draw_Ellipse_Repeat:
    mov     si, word [bp + ellipse_y0]  ; setPixel(x1, y0); /*   I. Quadrant */
    shl     si, 6                       ; point = y*320 + x
    mov     di, word [bp + ellipse_y0]
    shl     di, 8
    add     di, si
    add     di, word [bp + ellipse_x1]
    stosb

    mov     si, word [bp + ellipse_y0]  ; setPixel(x0, y0); /*  II. Quadrant */
    shl     si, 6
    mov     di, word [bp + ellipse_y0]
    shl     di, 8
    add     di, si
    add     di, word [bp + ellipse_x0]
    stosb

    mov     si, word [bp + ellipse_y1]  ; setPixel(x0, y1); /* III. Quadrant */
    shl     si, 6
    mov     di, word [bp + ellipse_y1]
    shl     di, 8
    add     di, si
    add     di, word [bp + ellipse_x0]
    stosb

    mov     si, word [bp + ellipse_y1]  ; setPixel(x1, y1); /*  IV. Quadrant */
    shl     si, 6
    mov     di, word [bp + ellipse_y1]
    shl     di, 8
    add     di, si
    add     di, word [bp + ellipse_x1]
    stosb

    mov     si, word [bp - err]         ; e2 = 2*err
    shl     si, 1
    mov     [bp - e2], si

; y step: if (e2 <= dy) { y0++; y1--; err += dy += a; }
    cmp     si, word [bp - delta_y]     ; if (e2 > dy) skip
    jg      skip_step_y
    inc     word [bp + ellipse_y0]      ; y0++
    dec     word [bp + ellipse_y1]      ; y1--
    mov     si, word [bp - delta_y]     ; dy += a
    add     si, word [bp - a]
    mov     [bp - delta_y], si
    mov     si, word [bp - err]         ; err += dy
    add     si, word [bp - delta_y]
    mov     [bp - err], si
skip_step_y:

; x step: if (e2 >= dx || 2*err > dy) { x0++; x1--; err += dx += b1; }
    mov     si, word [bp - e2]          ; if (e2 >= dx)
    cmp     si, word [bp - delta_x]
    jge     step_x
    mov     si, word [bp - err]         ; if (2*err <= dy) skip
    shl     si, 1
    cmp     si, word [bp - delta_y]
    jle     skip_step_x
step_x:
    inc     word [bp + ellipse_x0]      ; x0++
    dec     word [bp + ellipse_x1]      ; x1++
    mov     si, word [bp - delta_x]     ; dx += b1
    add     si, word [bp - b1]
    mov     [bp - delta_x], si
    mov     si, word [bp - err]         ; err += dx
    add     si, word [bp - delta_x]
    mov     [bp - err], si
skip_step_x:

;____________________
    mov     si, word [bp + ellipse_x0]  ; if (x0 <= x1) continue
    cmp     si, word [bp + ellipse_x1]
    jle     Draw_Ellipse_Repeat

Draw_Ellipse_Finish:
    mov     si, word [bp + ellipse_y0]  ; while (y0-y1 < b)
    sub     si, word [bp + ellipse_y1]
    cmp     si, word [bp - b]
    jge     end_ellipse_algorithm

    mov     si, word [bp + ellipse_y0]  ; setPixel(x0-1, y0);
    shl     si, 6                       ; point = y*320 + x
    mov     di, word [bp + ellipse_y0]
    shl     di, 8
    add     di, si
    mov     si, word [bp + ellipse_x0]
    dec     si
    add     di, si
    stosb

    mov     si, word [bp + ellipse_y0]  ; setPixel(x1+1, y0++);
    shl     si, 6
    mov     di, word [bp + ellipse_y0]
    shl     di, 8
    add     di, si
    mov     si, word [bp + ellipse_x1]
    inc     si
    add     di, si
    stosb
    inc     word [bp + ellipse_y0]

    mov     si, word [bp + ellipse_y1]  ; setPixel(x0-1, y1);
    shl     si, 6
    mov     di, word [bp + ellipse_y1]
    shl     di, 8
    add     di, si
    mov     si, word [bp + ellipse_x0]
    dec     si
    add     di, si
    stosb

    mov     si, word [bp + ellipse_y1]  ; setPixel(x1+1, y1--);
    shl     si, 6
    mov     di, word [bp + ellipse_y1]
    shl     di, 8
    add     di, si
    mov     si, word [bp + ellipse_x1]
    inc     si
    add     di, si
    stosb
    dec     word [bp + ellipse_y1]

    jmp     Draw_Ellipse_Finish

;____________________
end_ellipse_algorithm:
    pop     dx
    pop     cx
    pop     ax
    pop     si
    pop     di
    pop     es
    leave
    ret     10