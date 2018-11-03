%include "graphics_rectangle_main.asm"
%include "graphics_rectangle_algorithm.asm"

Graphics_Rectangle:
    push    50d    ; x0                 ; Default arguments
    push    50d    ; y0
    push    140d   ; width
    push    100d   ; height
    push    0d     ; pixel settings placeholder
    call    Graphics_Rectangle_Main

    ret

;____________________
Graphics_Rectangle_Setup:
    push    si

    mov     cx, word [bp + rect_x0]     ; Column start
    mov     dx, word [bp + rect_y0]     ; Row start

    mov     si, cx                      ; Column end
    add     si, word [bp + rect_w]
    mov     [bp - rect_row_end], si

    mov     si, dx                      ; Row end
    add     si, word [bp + rect_h]
    mov     [bp - rect_col_end], si

    mov     ax, word [bp + px_set]      ; AH: 0Ch, AL: colour

    pop     si
    ret