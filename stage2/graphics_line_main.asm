; Input:
; x0: [bp + 10]
; y0: [bp + 8]
; x1: [bp + 6]
; y1: [bp + 4]

Graphics_Line_Main:
    push    bp
    mov     bp, sp
    push    ax

return_line_menu:
    call    Graphics_Line_Menu

;____________________
main_menu_get_key:
    xor     ah, ah                      ; Get a keystroke
    int     16h

    cmp     ah, 01h                     ; exit
    jne     main_menu_option1
    pop     ax
    leave
    ret 8

main_menu_option1:
    cmp     ah, 02h
    jne     main_menu_option2
    push    word 10d    ; x0
    push    word 20d    ; y0
    push    word 310d   ; x1
    push    word 180d   ; y1
    jmp     end_main_menu

main_menu_option2:
    cmp     ah, 03h
    jne     main_menu_option3
    push    word 280d
    push    word 15d
    push    word 40d
    push    word 195d
    jmp     end_main_menu

main_menu_option3:
    cmp     ah, 04h
    jne     main_menu_option4
    push    word 200d
    push    word 120d
    push    word 15d
    push    word 5d
    jmp     end_main_menu

main_menu_option4:
    cmp     ah, 05h
    jne     main_menu_option5
    push    word 32d
    push    word 175d
    push    word 182d
    push    word 3d
    jmp     end_main_menu

main_menu_option5:
    cmp     ah, 06h
    jne     main_menu_option6

    call    Graphics_Set_Display_Mode

    push    word 10d    ; x0
    push    word 20d    ; y0
    push    word 310d   ; x1
    push    word 180d   ; y1
    push    word 0C0Ah
    call    Bresenham_Main

    push    word 280d
    push    word 15d
    push    word 40d
    push    word 195d
    push    word 0C0Ch
    call    Bresenham_Main

    push    word 200d
    push    word 120d
    push    word 15d
    push    word 5d
    push    word 0C0Eh
    call    Bresenham_Main

    push    word 32d
    push    word 175d
    push    word 182d
    push    word 3d
    push    word 0C0Fh
    call    Bresenham_Main

    call    Graphics_Done               ; Skip colour menu and tests.
    jmp     return_line_menu
    
main_menu_option6:                      ; Use default coordinates
    cmp     ah, 07h
    jne     main_menu_get_key
    push    word [bp + 10]  ; x0
    push    word [bp + 8]   ; y0
    push    word [bp + 6]   ; x1
    push    word [bp + 4]   ; y1

;____________________
end_main_menu:
    push    word 0C00h                  ; Default pixel settings

    call    Graphics_Colour_Menu
    call    Graphics_Set_Display_Mode
    call    Bresenham_Main

    call    Graphics_Done
    jmp     return_line_menu

;____________________
Graphics_Line_Menu:
    push    word graphics_line_menu_greeting
    call    Console_WriteLine_16
    call    New_Line_16
    push    word graphics_line_menu_prompt
    call    Console_WriteLine_16

    push    word graphics_line_menu_option1
    call    Console_WriteLine_16
    push    word graphics_line_menu_option2
    call    Console_WriteLine_16
    push    word graphics_line_menu_option3
    call    Console_WriteLine_16
    push    word graphics_line_menu_option4
    call    Console_WriteLine_16
    push    word graphics_line_menu_option5
    call    Console_WriteLine_16
    push    word graphics_line_menu_option6
    call    Console_WriteLine_16

    call    New_Line_16
    push    word graphics_menu_prompt_exit
    call    Console_WriteLine_16

    ret

;____________________
; Data
graphics_line_menu_greeting: db 'Bresenham`s line drawing algorithm implementation', 0
graphics_line_menu_prompt: db 'Choose one of the options below:', 0
graphics_line_menu_option1: db '1: (10, 20) -> (310, 180)', 0
graphics_line_menu_option2: db '2: (280, 15) -> (40, 195)', 0
graphics_line_menu_option3: db '3: (200, 120) -> (15, 5)', 0
graphics_line_menu_option4: db '4: (32, 175) -> (182, 3)', 0
graphics_line_menu_option5: db '5: Draw all of the above.', 0
graphics_line_menu_option6: db '6: Use default coordinates.', 0