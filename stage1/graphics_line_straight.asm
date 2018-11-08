Graphics_Line_Horizontal:
    mov     cx, word [x0]               ; temp = x0;
    cmp     cx, word [x1]               ; if (x0 <= x1) don't swap
    jle     skip_swap_x
    mov     si, word [x1]
    mov     [x0], si                    ; x0 = x1;
    mov     [x1], cx                    ; x1 = temp;
skip_swap_x:
    
    call    Graphics_Set_Display_Mode
    mov     dx, word [y0]               ; Y start
    mov     al, byte [pixel_colour]
    mov     ah, 0Ch                     ; Draw pixel instruction

horizontal_repeat:
    int     10h
    cmp     cx, word [x1]
    jne     horizontal_continue
    ret

horizontal_continue:
    inc     cx
    jmp     horizontal_repeat

;____________________
Graphics_Line_Vertical:
    mov     dx, word [y0]               ; temp = y0;
    cmp     dx, word [y1]               ; if (y0 <= y1) don't swap
    jle     skip_swap_y
    mov     si, word [y1]
    mov     [y0], si                    ; y0 = y1;
    mov     [y1], dx                    ; y1 = temp;
skip_swap_y:

    call    Graphics_Set_Display_Mode
    mov     cx, word [x0]               ; X start
    mov     al, byte [pixel_colour]
    mov     ah, 0Ch                     ; Draw pixel instruction

vertical_repeat:
    int     10h
    cmp     dx, word [y1]
    jne     vertical_continue
    ret

vertical_continue:
    inc     dx
    jmp     vertical_repeat