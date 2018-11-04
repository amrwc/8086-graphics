; Simplify the algorithm in the right conditions.
;
; Input:
;       x0: [bp + 12] -> [bp + x0]
;       y0: [bp + 10] -> [bp + y0]
;       x1: [bp + 8]  -> [bp + x1]
;       y1: [bp + 6]  -> [bp + y1]
; straight: [bp - 2]  -> [bp - straight]

Graphics_Line_Test_Straight:
    push    si

    mov     si, word [bp + x0]          ; if (x0 != x1) jmp is_horizontal;
    cmp     si, word [bp + x1]
    jne     is_horizontal
    mov     si, word [bp + y0]          ; if (y0 != y1) jmp is_vertical;
    cmp     si, word [bp + y1]
    je      end_line_test_straight
    mov     [bp - straight], word 2d    ; Draw vertical

end_line_test_straight:
    pop     si
    ret

is_horizontal:
    mov     si, word [bp + y0]          ; if (y0 != y0) break;
    cmp     si, word [bp + y1]
    jne     end_line_test_straight
    mov     [bp - straight], word 1d    ; Draw horizontal
    jmp     end_line_test_straight