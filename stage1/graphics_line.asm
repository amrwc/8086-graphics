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

Graphics_Line:
; Delta X
    mov     ax, word [x1]
    sub     ax, word [x0]

; Instead of doing '(x0 < x1) ? sx=1 : sx=-1',
; the program does '(x1 >= x0) ? sx=1 : sx=-1' by using the subtraction in place.
    jge     Skip_Direction_X
    mov     [sx], word -1d

Skip_Direction_X:
; cwd -- Convert word to doubleword, i.e. extend the sign bit of AX into DX.
    cwd                                 ; abs(dx)
    xor     ax, dx
    sub     ax, dx

    mov     [delta_x], ax               ; Store delta X

;____________________
; Delta Y
    mov     ax, word [y1]
    sub     ax, word [y0]
    jge     Skip_Direction_Y            ; (y1 >= y0) ? sy=1 : sy=-1
    mov     [sy], word -1d

Skip_Direction_Y:
    cwd                                 ; abs(dy)
    xor     ax, dx
    sub     ax, dx

    mov     [delta_y], ax               ; Store delta Y

;____________________
; Err
    mov     ax, word [delta_x]          ; err = dx - dy
    sub     ax, word [delta_y]
    mov     [err], ax

;____________________
;Graphics_Line_Main
    mov     ax, 0013h                   ; Set display mode to 320x200px, 256 colours, 1 page.
    int     10h
    mov     ah, 0Ch                     ; Draw pixel instruction

    mov     cx, word [y0]               ; Column start
    mov     dx, word [x0]               ; Row start
    mov     al, 0Ch                     ; Set pixel colour to light red.

Draw_Line_Loop_Repeat:
    int     10h                         ; Print pixel

    cmp     dx, word [x1]               ; if (x0==x1 && y0==y1) break;
    jne     Loop_Continue
    cmp     cx, word [y1]
    je      Graphics_Done               ; break

Loop_Continue:
    mov     si, word [err]              ; e2 = 2 * err
    mov     [e2], si

;Update_Row
    mov     si, word [delta_y]          ; if (e2 > -dy)
    neg     si
    cmp     word [e2], si
    jle     Update_Column

    mov     si, word [err]              ; err -= dy
    sub     si, word [delta_y]
    mov     [err], si
    add     dx, word [sx]               ; x0 += sx

Update_Column:
    mov     si, word [delta_x]
    cmp     word [e2], si
    jge     Draw_Line_Loop_Repeat

    mov     si, word [err]              ; err += dx
    add     si, word [delta_x]
    mov     [err], si
    add     cx, word [sy]               ; y0 += sy

    jmp     Draw_Line_Loop_Repeat

;____________________
Graphics_Done:
    xor     ax, ax                      ; getchar()
    int     16h

    mov     ax, 0003h                   ; Return to text mode
    int     10h
    ret

;____________________
; Data
    x0: dw 150d                         ; Line start
    y0: dw 100d
    x1: dw 15d                          ; Line end
    y1: dw 30d

    sx: dw 1d                           ; Direction variables
    sy: dw 1d
    delta_x: dw 0
    delta_y: dw 0
    err: dw 0
    e2: dw 0