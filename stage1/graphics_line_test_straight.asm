; Simplify the algorithm in the right conditions.
;is_dot
    mov     si, word [x0]               ; if (x0 != x1) jmp is_horizontal;
    cmp     si, word [x1]
    jne     is_horizontal
    mov     si, word [y0]               ; if (y0 != y1) jmp is_vertical;
    cmp     si, word [y1]
    jne     is_vertical

    call    Graphics_Setup
    int     10h
    jmp     Graphics_Done

;____________________
is_horizontal:
    jg      skip_direction_horizontal   ; if (x0 > x1) don't change flag
    mov     [direction_horizontal], word 1d
skip_direction_horizontal:
    mov     si, word [y0]               ; if (y0 != y0) break;
    cmp     si, word [y1]
    jne     end_test_straight
    call    Graphics_Setup

horizontal_repeat:
    int     10h
    cmp     cx, word [x1]
    jne     horizontal_continue
    je      Graphics_Done

horizontal_continue:
    add     cx, word [direction_horizontal]
    jmp     horizontal_repeat

;____________________
is_vertical:
    jg      skip_direction_vertical
    mov     [direction_vertical], word 1d
skip_direction_vertical:
    call    Graphics_Setup

vertical_repeat:
    int     10h
    cmp     dx, word [y1]
    jne     vertical_continue
    je      Graphics_Done

vertical_continue:
    add     dx, word [direction_vertical]
    jmp     vertical_repeat

;____________________
; Data:
direction_horizontal: dw -1d
direction_vertical: dw -1d

end_test_straight: