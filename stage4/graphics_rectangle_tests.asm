Graphics_Rectangle_Tests:
    push    si

;is_width_negative:
    cmp     [bp + rect_w], word 0       ; if (w < 0) w = -w;
    jg      is_rect_width_over_320
    je      rect_new_width              ; if (w == 0) w = 1;
    neg     word [bp + rect_w]
    jmp     is_rect_width_over_320
rect_new_width:
    mov     [bp + rect_w], word 1d
    jmp     is_rect_height_negative
is_rect_width_over_320:
    cmp     [bp + rect_w], word 320     ; if (w > 320) w = 320;
    jle     is_rect_height_negative
    mov     [bp + rect_w], word 320d

;____________________
is_rect_height_negative:
    cmp     [bp + rect_h], word 0       ; if (h < 0) h = -h;
    jg      is_rect_height_over_200
    je      rect_new_height             ; if (h == 0) h = 1;
    neg     word [bp + rect_h]
    jmp     is_rect_height_over_200
rect_new_height:
    mov     [bp + rect_h], word 1d
    jmp     is_rect_x0_negative
is_rect_height_over_200:
    cmp     [bp + rect_h], word 200d    ; if (h > 200) h = 200;
    jle     is_rect_x0_negative
    mov     [bp + rect_h], word 200d

;____________________
is_rect_x0_negative:
    cmp     [bp + rect_x0], word 0
    jg      is_rect_x0_over_319
    je      is_row_end_beyond_boundary
    mov     [bp + rect_x0], word 0      ; Default x0 to 0.
    jmp     is_row_end_beyond_boundary
is_rect_x0_over_319:
    cmp     [bp + rect_x0], word 319d
    jle     is_row_end_beyond_boundary
    mov     si, 320d
    sub     si, word [bp + rect_w]
    mov     [bp + rect_x0], si
    jmp     is_rect_y0_negative

is_row_end_beyond_boundary:
    mov     si, word [bp + rect_x0]     ; Row end (last column x)
    add     si, word [bp + rect_w]
    cmp     si, word 319d
    jle     is_rect_y0_negative
    mov     si, 320d
    sub     si, word [bp + rect_w]
    mov     [bp + rect_x0], si

;____________________
is_rect_y0_negative:
    cmp     [bp + rect_y0], word 0
    jg      is_rect_y0_over_199
    je      is_col_end_beyond_boundary
    mov     [bp + rect_y0], word 0      ; Default y0 to 0.
    jmp     is_col_end_beyond_boundary
is_rect_y0_over_199:
    cmp     [bp + rect_y0], word 199d
    jle     is_col_end_beyond_boundary
    mov     si, 200d
    sub     si, word [bp + rect_h]
    mov     [bp + rect_y0], si
    jmp     end_rect_tests

is_col_end_beyond_boundary:
    mov     si, word [bp + rect_y0]     ; Column end (last row y)
    add     si, word [bp + rect_h]
    cmp     si, word 199d
    jle     end_rect_tests
    mov     si, 200d
    sub     si, word [bp + rect_h]
    mov     [bp + rect_y0], si

;____________________
end_rect_tests:
    pop     si
    ret