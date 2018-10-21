; Prevent drawing beyond boundaries.
    cmp     word [x0], 0                ; 0 <= x0 <= 200
    jge     is_x0_over_200
    mov     word [x0], 0000h
    jmp     is_x1_below_0
is_x0_over_200:
    cmp     word [x0], 200d
    jle     is_x1_below_0
    mov     word [x0], 200d

is_x1_below_0:                          ; 0 <= x1 <= 200
    cmp     word [x1], 0
    jge     is_x1_over_200
    mov     word [x1], 0000h
    jmp     is_y0_below_0
is_x1_over_200:
    cmp     word [x1], 200d
    jle     is_y0_below_0
    mov     word [x1], 200d

is_y0_below_0:                          ; 0 <= y0 <= 320
    cmp     word [y0], 0
    jge     is_y0_over_320
    mov     word [y0], 0000h
    jmp     is_y1_below_0
is_y0_over_320:
    cmp     word [y0], 320d
    jle     is_y1_below_0
    mov     word [y0], 320d

is_y1_below_0:                          ; 0 <= y1 <= 320
    cmp     word [y1], 0
    jge     is_y1_over_320
    mov     word [y1], 0000h
is_y1_over_320:
    cmp     word [y1], 320d
    jle     end_tests
    mov     word [y1], 320d

end_tests: