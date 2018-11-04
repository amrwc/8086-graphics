; Input:
; x0: [bp + 12] -> [bp + rect_x0]
; y0: [bp + 10] -> [bp + rect_y0]
;  w: [bp + 8]  -> [bp + rect_w]
;  h: [bp + 6]  -> [bp + rect_h]
; px: [bp + 4]  -> [bp + px_set]

%assign rect_x0 12
%assign rect_y0 10
%assign rect_w  8
%assign rect_h  6
%assign px_set  4

%assign rect_row_end  2
%assign rect_col_end  4

%include "graphics_rectangle_test_dimensions.asm"
%include "graphics_rectangle_test_boundaries.asm"

Graphics_Rectangle_Algorithm:
    push    bp
    mov     bp, sp
    sub     sp, 4
    push    cx
    push    dx
    push    si

;____________________
; Setup
    call    Graphics_Rectangle_Test_Dimensions

    mov     si, word [bp + rect_x0]     ; Column end
    add     si, word [bp + rect_w]
    mov     [bp - rect_row_end], si
    mov     si, word [bp + rect_y0]     ; Row end
    add     si, word [bp + rect_h]
    mov     [bp - rect_col_end], si

    call    Graphics_Rectangle_Test_Boundaries

    mov     cx, word [bp + rect_x0]     ; Column start
    mov     dx, word [bp + rect_y0]     ; Row start
    mov     ax, word [bp + px_set]      ; AH: 0Ch, AL: colour

    jmp     Draw_Rectangle_Inner        ; Skip the first inc.

Draw_Rectangle_Repeat:
    inc     cx
Draw_Rectangle_Inner:
    int     10h
    cmp     cx, word [bp - rect_row_end]; if (x != w) continue;
    jne     Draw_Rectangle_Repeat

    mov     cx, [bp + rect_x0]          ; Get back to the start of the line.
    inc     dx
    cmp     dx, word [bp - rect_col_end]; if (y = h) break;
    jle     Draw_Rectangle_Inner

    pop     si
    pop     dx
    pop     cx
    leave
    ret 10