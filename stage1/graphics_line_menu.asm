    mov     si, graphics_line_menu
    call    Console_WriteLine_16
    mov     si, graphics_line_prompt_colours
    call    Console_WriteLine_16
    call    New_Line_16
    mov     si, graphics_line_prompt_exit
    call    Console_WriteLine_16

Get_key:
    mov     ah, 00h                     ; Get a keystroke
    int     16h
;red:
    cmp     ah, 13h
    jne     green
    mov     byte [pixel_colour], 0Ch
    jmp     end_menu
green:
    cmp     ah, 22h
    jne     blue
    mov     byte [pixel_colour], 0Ah
    jmp     end_menu
blue:
    cmp     ah, 30h
    jne     white
    mov     byte [pixel_colour], 09h
    jmp     end_menu
white:
    cmp     ah, 11h
    jne     exit
    mov     byte [pixel_colour], 0Fh
    jmp     end_menu
exit:
    cmp     ah, 01h
    jne     Get_key
    mov     ax, 0003h                   ; Clear screen
    int     10h
    ret

graphics_line_menu: db 'Choose a colour:', 0
graphics_line_prompt_colours: db '(R)ed, (G)reen, (B)lue, (W)hite', 0
graphics_line_prompt_exit: db 'Press (ESC) to leave Line Drawing', 0
pixel_colour: db 0

end_menu: