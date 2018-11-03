; Input:
; x0: [bp + 12] -> [bp + rect_x0]
; y0: [bp + 10] -> [bp + rect_y0]
;  w: [bp + 8]  -> [bp + rect_w]
;  h: [bp + 6]  -> [bp + rect_h]
; px: [bp + 4]  -> [bp + px_set]

%assign rect_row_end  2
%assign rect_col_end  4

Graphics_Rectangle_Algorithm:
    push    bp
    mov     bp, sp
    sub     sp, 4
    push    cx
    push    dx
    push    si

    call    Graphics_Rectangle_Setup
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
    jne     Draw_Rectangle_Inner

    pop     si
    pop     dx
    pop     cx
    leave
    ret 10