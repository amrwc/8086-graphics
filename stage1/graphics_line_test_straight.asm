; Simplify the algorithm in the right conditions.
Graphics_Line_Test_Straight:
;is_dot
    mov     si, word [x0]               ; if (x0 != x1) jmp is_horizontal;
    cmp     si, word [x1]
    jne     is_horizontal
    mov     si, word [y0]               ; if (y0 == y1) break;
    cmp     si, word [y1]
    je      end_line_test_straight
    mov     [straight_line], byte 2d    ; Draw vertical

end_line_test_straight:
    ret

;____________________
is_horizontal:
    mov     si, word [y0]
    cmp     si, word [y1]
    jne     end_line_test_straight
    mov     [straight_line], byte 1d    ; Draw horizontal
    jmp     end_line_test_straight