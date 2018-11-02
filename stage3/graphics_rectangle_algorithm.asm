; Input:
; x0: [bp + 12] -> [bp + rect_x0]
; y0: [bp + 10] -> [bp + rect_y0]
; x1: [bp + 8]  -> [bp + rect_x1]
; y1: [bp + 6]  -> [bp + rect_y1]
; px: [bp + 4]  -> [bp + px_set]

%assign rect_sx  2
%assign rect_sy  4

Graphics_Rectangle_Algorithm:
    push    bp
    mov     bp, sp
    sub     sp, 4
    push    cx
    push    dx
    push    si

    mov     [bp - rect_sx], word 1d
    mov     [bp - rect_sy], word 1d

;____________________
; Direction tests
    mov     si, word [bp + rect_x0]     ; if (x0 > x1) sx = -1;
    cmp     si, word [bp + rect_x1]
    jle     rect_test_sy
    mov     [bp - rect_sx], word -1d
rect_test_sy:
    mov     si, word [bp + rect_y0]     ; if (y0 > y1) sy = -1;
    cmp     si, word [bp + rect_y1]
    jle     rect_test_end
    mov     [bp - rect_sy], word -1d
rect_test_end:

    call    Graphics_Rectangle_Setup
    jmp     Draw_Rectangle_Inner        ; Skip the first inc.

Draw_Rectangle_Repeat:
    add     cx, word [bp - rect_sx]
Draw_Rectangle_Inner:
    int     10h
    cmp     cx, word [bp + rect_x1]     ; Is column equal to end column?
    jnz     Draw_Rectangle_Repeat

    mov     cx, [bp + rect_x0]          ; Get back to the start of the line.
    add     dx, [bp - rect_sy]
    cmp     dx, word [bp + rect_y1]     ; Is row equal to end row?
    jnz     Draw_Rectangle_Inner

    pop     si
    pop     dx
    pop     cx
    leave
    ret 10