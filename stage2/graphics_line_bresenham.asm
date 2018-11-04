; 8086 Assembly Bresenham’s line drawing algorithm implementation.
; Pseudo-code:
;
; function drawLine(x0, y0, x1, y1, colour)
;   dx = abs(x1 - x0)
;   dy = abs(y1 - y0)
;   (x0 < x1) ? sx = 1 : sx = -1
;   (y0 < y1) ? sx = 1 : sx = -1
;   err = dx - dy
;   loop
;     printPixel(x0, y0, colour)
;     if (x0 = x1) and (y0 = y1) exit loop
;     e2 = 2 * err
;     if (e2 > -dy) then
;       err = err - dy
;       x0 = x0 + sx
;     end if
;     if (e2 < dx) then
;       err = err + dx
;       y0 = y0 + sy
;     end if
;   end loop
;
; Input:
; x0: [bp + 12] -> [bp + x0]
; y0: [bp + 10] -> [bp + y0]
; x1: [bp + 8]  -> [bp + x1]
; y1: [bp + 6]  -> [bp + y1]
; px: [bp + 4]  -> [bp + px_set]

%assign x0     12
%assign y0     10
%assign x1     8
%assign y1     6
%assign px_set 4

; Local variables:
%assign straight 2  ; [bp - straight]
%assign sx       4  ; [bp - sx]         ; Direction variables
%assign sy       6  ; [bp - sy]
%assign delta_x  8  ; [bp - delta_x]
%assign delta_y  10 ; [bp - delta_y]
%assign err      12 ; [bp - err]
%assign e2       14 ; [bp - e2]

%include "graphics_line_test_boundaries.asm"
%include "graphics_line_test_straight.asm"
%include "graphics_line_straight.asm"

Bresenham_Main:
    push    bp
    mov     bp, sp
    sub     sp, 14
    push    ax
    push    cx
    push    dx
    push    si

; Tests
    mov     [bp - straight], word 0
    call    Graphics_Line_Test_Boundaries
    call    Graphics_Line_Test_Straight

    cmp     [bp - straight], word 1d
    jl      Draw_Bresenham
    je      Draw_Horizontal

;Draw_Vertical:
    call    Graphics_Line_Vertical
    jmp     end_draw_line

Draw_Horizontal:
    call    Graphics_Line_Horizontal
    jmp     end_draw_line

Draw_Bresenham:
    mov     [bp - sx], word 1d          ; Set direction variables
    mov     [bp - sy], word 1d

;____________________
; Delta X
    mov     ax, word [bp + x1]
    sub     ax, word [bp + x0]

; Instead of doing '(x0 < x1) ? sx=1 : sx=-1',
; the program does '(x1 >= x0) ? sx=1 : sx=-1' by using the subtraction in place.
    jge     Skip_Direction_X
    mov     [bp - sx], word -1d

Skip_Direction_X:
; cwd -- Convert word to doubleword, i.e. extend the sign bit of AX into DX.
    cwd                                 ; abs(dx)
    xor     ax, dx
    sub     ax, dx

    mov     [bp - delta_x], ax          ; Store delta X

;____________________
; Delta Y
    mov     ax, word [bp + y1]
    sub     ax, word [bp + y0]
    jge     Skip_Direction_Y            ; (y1 >= y0) ? sy=1 : sy=-1
    mov     [bp - sy], word -1d

Skip_Direction_Y:
    cwd                                 ; abs(dy)
    xor     ax, dx
    sub     ax, dx

    mov     [bp - delta_y], ax          ; Store delta Y

;____________________
; Err
    mov     ax, word [bp - delta_x]     ; err = dx - dy
    sub     ax, word [bp - delta_y]
    mov     [bp - err], ax

; Setup
    mov     cx, word [bp + x0]          ; Column start
    mov     dx, word [bp + y0]          ; Row start
    mov     ax, word [bp + px_set]      ; AH: 0Ch, AL: colour

;____________________
Draw_Line_Loop_Repeat:
    int     10h                         ; Print pixel

    cmp     cx, word [bp + x1]          ; if (x0==x1 && y0==y1) break;
    jne     Loop_Continue
    cmp     dx, word [bp + y1]
    jne     Loop_Continue

end_draw_line:                          ; break
    pop     si
    pop     dx
    pop     cx
    pop     ax
    leave
    ret 10

Loop_Continue:
    mov     si, word [bp - err]         ; e2 = 2 * err
    add     si, word [bp - err]
    mov     [bp - e2], si

;Update_Row
    mov     si, word [bp - delta_y]     ; if (e2 > -dy)
    neg     si
    cmp     word [bp - e2], si
    jle     Update_Column

    mov     si, word [bp - err]         ; err -= dy
    sub     si, word [bp - delta_y]
    mov     [bp - err], si
    add     cx, word [bp - sx]          ; x0 += sx

Update_Column:
    mov     si, word [bp - delta_x]
    cmp     word [bp - e2], si
    jge     Draw_Line_Loop_Repeat

    mov     si, word [bp - err]         ; err += dx
    add     si, word [bp - delta_x]
    mov     [bp - err], si
    add     dx, word [bp - sy]          ; y0 += sy

    jmp     Draw_Line_Loop_Repeat