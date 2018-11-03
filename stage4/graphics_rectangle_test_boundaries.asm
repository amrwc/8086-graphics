Graphics_Rectangle_Test_Boundaries:
    push    si

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
    jmp     end_rect_test_boundaries

is_col_end_beyond_boundary:
    mov     si, word [bp + rect_y0]     ; Column end (last row y)
    add     si, word [bp + rect_h]
    cmp     si, word 199d
    jle     end_rect_test_boundaries
    mov     si, 200d
    sub     si, word [bp + rect_h]
    mov     [bp + rect_y0], si

;____________________
end_rect_test_boundaries:
    pop     si
    ret