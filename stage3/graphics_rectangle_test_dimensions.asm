Graphics_Rectangle_Test_Dimensions:
;is_width_negative:
    cmp     [bp + rect_w], word 0       ; if (w < 0) w = -w;
    jge     is_rect_width_over_319
    neg     word [bp + rect_w]
is_rect_width_over_319:
    cmp     [bp + rect_w], word 319     ; if (w > 319) w = 319;
    jle     is_rect_height_negative
    mov     [bp + rect_w], word 319d

is_rect_height_negative:
    cmp     [bp + rect_h], word 0       ; if (h < 0) h = -h;
    jge     is_rect_height_over_199
    neg     word [bp + rect_h]
is_rect_height_over_199:
    cmp     [bp + rect_h], word 199d    ; if (h > 199) h = 199;
    jle     end_rect_test_dimensions
    mov     [bp + rect_h], word 199d

end_rect_test_dimensions:
    ret