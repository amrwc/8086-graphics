Graphics_Line_Horizontal:
    mov     cx, word [bp + x0]          ; temp = x0;
    cmp     cx, word [bp + x1]          ; if (x0 <= x1) don't swap
    jle     skip_swap_x
    mov     si, word [bp + x1]
    mov     [bp + x0], si               ; x0 = x1;
    mov     [bp + x1], cx               ; x1 = temp;
skip_swap_x:
    
    call    Graphics_Set_Display_Mode
    mov     dx, word [bp + y0]          ; Y start
    mov     ax, word [bp + px_set]      ; AH: 0Ch, AL: chosen colour

horizontal_repeat:
    int     10h
    cmp     cx, word [bp + x1]
    jne     horizontal_continue
    ret

horizontal_continue:
    inc     cx
    jmp     horizontal_repeat

;____________________
Graphics_Line_Vertical:
    mov     dx, word [bp + y0]          ; temp = y0;
    cmp     dx, word [bp + y1]          ; if (y0 <= y1) don't swap
    jle     skip_swap_y
    mov     si, word [bp + y1]
    mov     [bp + y0], si               ; y0 = y1;
    mov     [bp + y1], dx               ; y1 = temp;
skip_swap_y:

    call    Graphics_Set_Display_Mode
    mov     cx, word [bp + x0]          ; X start
    mov     ax, word [bp + px_set]      ; AH: 0Ch, AL: chosen colour

vertical_repeat:
    int     10h
    cmp     dx, word [bp + y1]
    jne     vertical_continue
    ret

vertical_continue:
    inc     dx
    jmp     vertical_repeat