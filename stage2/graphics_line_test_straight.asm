; Simplify the algorithm in the right conditions.
;
; Input:
; x0: [bp + 4]  -> [bp + x0]
; y0: [bp + 6]  -> [bp + y0]
; x1: [bp + 8]  -> [bp + x1]
; y1: [bp + 10] -> [bp + y1]

Test_Straight:
    push    bp
    mov     bp, sp
    push    cx
    push    dx
    push    si

    mov     si, word [bp + x0]          ; if (x0 != x1) jmp is_horizontal;
    cmp     si, word [bp + x1]
    jne     is_horizontal
    mov     si, word [bp + y0]          ; if (y0 != y1) jmp is_vertical;
    cmp     si, word [bp + y1]
    jne     is_vertical

normal_bresenham:
    push    word [bp + y1]
    push    word [bp + x1]
    push    word [bp + y0]
    push    word [bp + x0]

    call    Graphics_Set_Display_Mode
    call    Bresenham_Main
    call    Graphics_Done

    jmp     end_test_straight

;____________________
is_horizontal:
    jg      skip_direction_horizontal   ; if (x0 > x1) don't change flag
    mov     [direction_horizontal], word 1d
skip_direction_horizontal:
    mov     si, word [bp + y0]          ; if (y0 != y0) break;
    cmp     si, word [bp + y1]
    jne     normal_bresenham
    call    Graphics_Set_Display_Mode
    call    Graphics_Setup

horizontal_repeat:
    int     10h
    cmp     cx, word [bp + x1]
    jne     horizontal_continue
    call    Graphics_Done
    jmp     end_test_straight

horizontal_continue:
    add     cx, word [direction_horizontal]
    jmp     horizontal_repeat

;____________________
is_vertical:
    jg      skip_direction_vertical
    mov     [direction_vertical], word 1d
skip_direction_vertical:
    call    Graphics_Set_Display_Mode
    call    Graphics_Setup

vertical_repeat:
    int     10h
    cmp     dx, word [bp + y1]
    jne     vertical_continue
    call    Graphics_Done
    jmp     end_test_straight

vertical_continue:
    add     dx, word [direction_vertical]
    jmp     vertical_repeat

;____________________
end_test_straight:
    mov     [direction_horizontal], word -1d
    mov     [direction_vertical], word -1d
    pop     si
    pop     dx
    pop     cx
    leave
    ret 8

;____________________
; Data:
direction_horizontal: dw -1d
direction_vertical: dw -1d