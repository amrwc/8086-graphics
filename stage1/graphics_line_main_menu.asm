; Input:
; dw x0, x1, y0, y1

Graphics_Line_Main_Menu:
    mov     si, graphics_line_main_menu_prompt
    call    Console_WriteLine_16

    mov     si, graphics_line_main_menu_option1
    call    Console_WriteLine_16
    mov     si, graphics_line_main_menu_option2
    call    Console_WriteLine_16
    mov     si, graphics_line_main_menu_option3
    call    Console_WriteLine_16
    mov     si, graphics_line_main_menu_option4
    call    Console_WriteLine_16
    mov     si, graphics_line_main_menu_option5
    call    Console_WriteLine_16
    mov     si, graphics_line_main_menu_option6
    call    Console_WriteLine_16

    mov     si, graphics_line_menu_prompt_exit
    call    Console_WriteLine_16

;____________________
main_menu_get_key:
    xor     ah, ah                      ; Get a keystroke
    int     16h

    cmp     ah, 01h                     ; exit
    jne     main_menu_option1
    mov     ax, 0003h                   ; Clear screen
    int     10h
    ret

main_menu_option1:
    cmp     ah, 02h
    jne     main_menu_option2
    mov     [x0], word 10d
    mov     [y0], word 20d
    mov     [x1], word 310d
    mov     [y1], word 180d
    jmp     end_main_menu

main_menu_option2:
    cmp     ah, 03h
    jne     main_menu_option3
    mov     [x0], word 280d
    mov     [y0], word 15d
    mov     [x1], word 40d
    mov     [y1], word 195d
    jmp     end_main_menu

main_menu_option3:
    cmp     ah, 04h
    jne     main_menu_option4
    mov     [x0], word 200d
    mov     [y0], word 120d
    mov     [x1], word 15d
    mov     [y1], word 5d
    jmp     end_main_menu

main_menu_option4:
    cmp     ah, 05h
    jne     main_menu_option5
    mov     [x0], word 32d
    mov     [y0], word 175d
    mov     [x1], word 182d
    mov     [y1], word 3d
    jmp     end_main_menu

main_menu_option5:
    cmp     ah, 06h
    jne     main_menu_option6

    call    Graphics_Set_Display_Mode

    mov     [x0], word 10d
    mov     [y0], word 20d
    mov     [x1], word 310d
    mov     [y1], word 180d
    mov     [pixel_colour], byte 0Ah
    call    Bresenham_Main

    mov     [x0], word 280d
    mov     [y0], word 15d
    mov     [x1], word 40d
    mov     [y1], word 195d
    mov     [pixel_colour], byte 0Ch
    call    Bresenham_Main

    mov     [x0], word 200d
    mov     [y0], word 120d
    mov     [x1], word 15d
    mov     [y1], word 5d
    mov     [pixel_colour], byte 0Eh
    call    Bresenham_Main

    mov     [x0], word 32d
    mov     [y0], word 175d
    mov     [x1], word 182d
    mov     [y1], word 3d
    mov     [pixel_colour], byte 0Fh
    call    Bresenham_Main

    jmp     Graphics_Done

main_menu_option6:
    cmp     ah, 07h                     ; On subsequent runs, repeats the last option.
    jne     main_menu_get_key
    mov     [x0], word 27d              ; DEFAULT ARGUMENTS
    mov     [y0], word 170d
    mov     [x1], word 288d
    mov     [y1], word 88d
    jmp     end_main_menu

;____________________
; Data
graphics_line_main_menu_prompt: db 'Choose one of the options below:', 0
graphics_line_main_menu_option1: db '1: (10, 20) -> (310, 180)', 0
graphics_line_main_menu_option2: db '2: (280, 15) -> (40, 195)', 0
graphics_line_main_menu_option3: db '3: (200, 120) -> (15, 5)', 0
graphics_line_main_menu_option4: db '4: (32, 175) -> (182, 3)', 0
graphics_line_main_menu_option5: db '5: Draw all of the above.', 0
graphics_line_main_menu_option6: db '6: Use default coordinates.', 0

end_main_menu:
    mov     ax, 0003h
    int     10h