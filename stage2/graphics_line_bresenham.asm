; 8086 Assembly Bresenham’s line drawing algorithm.
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
; x0: [bp + 4]  -> [bp + x0]
; y0: [bp + 6]  -> [bp + y0]
; x1: [bp + 8]  -> [bp + x1]
; y1: [bp + 10] -> [bp + y1]
;
; Local variables:
%assign sx      2   ; [bp - sx]         ; Direction variables
%assign sy      4   ; [bp - sy]
%assign delta_x 6   ; [bp - delta_x]
%assign delta_y 8   ; [bp - delta_y]
%assign err     10  ; [bp - err]
%assign e2      12  ; [bp - e2]

Bresenham_Main:
    push    bp
    mov     bp, sp
    sub     sp, 12
    push    ax
    push    cx
    push    dx
    push    si

; Set direction variables
    mov     [bp - sx], word 1d
    mov     [bp - sy], word 1d

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

    call    Graphics_Setup

;____________________
;Graphics_Line_Algorithm
Draw_Line_Loop_Repeat:
    int     10h                         ; Print pixel

    cmp     cx, word [bp + x1]          ; if (x0==x1 && y0==y1) break;
    jne     Loop_Continue
    cmp     dx, word [bp + y1]
    jne     Loop_Continue

; Reset direction arguments. Only necessary for the menu to work correctly.
    mov     [bp - sx], word 1d          ; break
    mov     [bp - sy], word 1d

    pop     si
    pop     dx
    pop     cx
    pop     ax
    leave
    ret 8

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