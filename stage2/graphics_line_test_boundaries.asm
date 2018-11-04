; Prevent drawing beyond boundaries.
;
; Input:
; x0: [bp + 12] -> [bp + x0]
; y0: [bp + 10] -> [bp + y0]
; x1: [bp + 8]  -> [bp + x1]
; y1: [bp + 6]  -> [bp + y1]

Graphics_Line_Test_Boundaries:
;is_x0_negative:
    cmp     [bp + x0], word 0
    jg      is_x0_over_319
    je      is_x1_negative
    mov     [bp + x0], word 0
    jmp     is_x1_negative
is_x0_over_319:
    cmp     [bp + x0], word 319d
    jle     is_x1_negative
    mov     [bp + x0], word 319d

;____________________
is_x1_negative:
    cmp     [bp + x1], word 0
    jg      is_x1_over_319
    je      is_y0_negative
    mov     [bp + x1], word 0
    jmp     is_y0_negative
is_x1_over_319:
    cmp     [bp + x1], word 319d
    jle     is_y0_negative
    mov     [bp + x1], word 319d

;____________________
is_y0_negative:
    cmp     [bp + y0], word 0
    jg      is_y0_over_199
    je      is_y1_negative
    mov     [bp + y0], word 0
    jmp     is_y1_negative
is_y0_over_199:
    cmp     [bp + y0], word 199d
    jle     is_y1_negative
    mov     [bp + y0], word 199d

;____________________
is_y1_negative:
    cmp     [bp + y1], word 0
    jg      is_y1_over_199
    je      end_test_boundaries
    mov     [bp + y1], word 0
    jmp     end_test_boundaries
is_y1_over_199:
    cmp     [bp + y1], word 199d
    jle     end_test_boundaries
    mov     [bp + y1], word 199d

end_test_boundaries:
    ret