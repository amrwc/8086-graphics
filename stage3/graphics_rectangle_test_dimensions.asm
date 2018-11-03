Graphics_Rectangle_Test_Dimensions:
;is_width_negative:
    cmp     [bp + rect_w], word 0
    jg      is_height_negative
    mov     [bp + rect_w], word 10d

is_height_negative:
    cmp     [bp + rect_h], word 0
    jg      end_rect_test_dimensions
    mov     [bp + rect_h], word 10d

end_rect_test_dimensions:
    ret