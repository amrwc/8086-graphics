Graphics_Circle_Tests:
    push    si

;is_radius_negative:
    cmp     [bp + circ_r], word 0d      ; if (r < 0) r = -r;
    jge     is_radius_beyond_screen
    neg     word [bp + circ_r]

is_radius_beyond_screen:
    cmp     [bp + circ_r], word 99d     ; if (r > 99) r = 99;
    jle     is_circ_xm_negative
    mov     [bp + circ_r], word 99d

is_circ_xm_negative:
    cmp     [bp + circ_xm], word 0
    je      is_circ_ym_negative
    jg      is_circ_xm_over_319
    mov     si, word 0
    add     si, [bp + circ_r]
    mov     [bp + circ_xm], si
    jmp     is_circ_ym_negative

is_circ_xm_over_319:
    cmp     [bp + circ_xm], word 319d
    jle     is_circ_ym_negative
    mov     si, word 320d
    sub     si, [bp + circ_r]
    mov     [bp + circ_xm], si

is_circ_ym_negative:
    cmp     [bp + circ_ym], word 0
    je      is_circle_beyond_left
    jg      is_circ_ym_over_199
    mov     si, word 0
    add     si, [bp + circ_r]
    mov     [bp + circ_ym], si
    jmp     is_circle_beyond_left

is_circ_ym_over_199:
    cmp     [bp + circ_ym], word 199d
    jle     is_circle_beyond_left
    mov     si, word 200d
    sub     si, [bp + circ_r]
    mov     [bp + circ_ym], si

is_circle_beyond_left:
    mov     si, [bp + circ_xm]          ; if (x-r < 0) x = r;
    sub     si, [bp + circ_r]
    cmp     si, word 0
    jge     is_circle_beyond_right
    mov     si, [bp + circ_r]
    mov     [bp + circ_xm], si
    jmp     is_circle_beyond_top

is_circle_beyond_right:
    mov     si, [bp + circ_xm]          ; if (x+r > 319) x = 319-r;
    add     si, [bp + circ_r]
    cmp     si, word 319d
    jle     is_circle_beyond_top
    mov     si, word 319d
    sub     si, [bp + circ_r]
    mov     [bp + circ_xm], si

is_circle_beyond_top:
    mov     si, [bp + circ_ym]          ; if (y-r < 0) y = r;
    sub     si, [bp + circ_r]
    cmp     si, word 0
    jge     is_circle_beyond_bottom
    mov     si, [bp + circ_r]
    mov     [bp + circ_ym], si
    jmp     end_tests_circle

is_circle_beyond_bottom:
    mov     si, [bp + circ_ym]          ; if (y+r > 199) y = 199-r
    add     si, [bp + circ_r]
    cmp     si, word 199d
    jle     end_tests_circle
    mov     si, word 199d
    sub     si, [bp + circ_r]
    mov     [bp + circ_ym], si

end_tests_circle:
    pop     si
    ret