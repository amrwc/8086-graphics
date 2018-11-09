; Input:
; x0: [bp + 10]
; y0: [bp + 8]
; x1: [bp + 6]
; y1: [bp + 4]

Graphics_Ellipse_Main:
    push    bp
    mov     bp, sp
    push    ax

    call    Graphics_Ellipse_Menu

;____________________
ellipse_menu_get_key:
    xor     ah, ah                      ; Get a keystroke
    int     16h

    cmp     ah, 01h                     ; exit
    jne     ellipse_menu_option1
    call    Halt

ellipse_menu_option1:
    cmp     ah, 02h
    jne     ellipse_menu_option2
    push    word 100d  ; x0
    push    word 50d   ; y0
    push    word 115d  ; x1
    push    word 60d   ; y1
    jmp     end_ellipse_menu

ellipse_menu_option2:
    cmp     ah, 03h
    jne     ellipse_menu_option3
    push    word 10d
    push    word 100d
    push    word 150d
    push    word 25d
    jmp     end_ellipse_menu

ellipse_menu_option3:
    cmp     ah, 04h
    jne     ellipse_menu_option4

    call    Graphics_Set_Display_Mode

    push    word 100d  ; x0
    push    word 50d   ; y0
    push    word 115d  ; x1
    push    word 60d   ; y1
    push    word 0C0Ch ; px_set
    call    Graphics_Ellipse_Algorithm

    push    word 10d
    push    word 100d
    push    word 150d
    push    word 25d
    push    word 0C09h
    call    Graphics_Ellipse_Algorithm

    call    Graphics_Done

    pop     ax
    leave
    ret 8

ellipse_menu_option4:                   ; Use default coordinates
    cmp     ah, 05h
    jne     ellipse_menu_get_key
    push    word [bp + 10] ; x0
    push    word [bp + 8]  ; y0
    push    word [bp + 6]  ; x1
    push    word [bp + 4]  ; y1

end_ellipse_menu:
    push    word 0C00h                  ; Default pixel settings.

    call    Graphics_Colour_Menu
    call    Graphics_Set_Display_Mode
    call    Graphics_Ellipse_Algorithm
    call    Graphics_Done

    pop     ax
    leave
    ret 8

;____________________
Graphics_Ellipse_Menu:
    mov     ax, 0003h                   ; Clear screen
    int     10h

    push    word graphics_ellipse_menu_prompt
    call    Console_WriteLine_16

    push    word graphics_ellipse_menu_option1
    call    Console_WriteLine_16
    push    word graphics_ellipse_menu_option2
    call    Console_WriteLine_16
    push    word graphics_ellipse_menu_option3
    call    Console_WriteLine_16
    push    word graphics_ellipse_menu_option4
    call    Console_WriteLine_16

    call    New_Line_16
    push    word graphics_menu_prompt_exit
    call    Console_WriteLine_16

    ret

;____________________
; Data
graphics_ellipse_menu_prompt: db 'Choose one of the options below:', 0
graphics_ellipse_menu_option1: db '1: (100, 50) -> (115, 60)', 0
graphics_ellipse_menu_option2: db '2: Error (50, 100) -> (250, 25)', 0
graphics_ellipse_menu_option3: db '3: Draw all of the above.', 0
graphics_ellipse_menu_option4: db '4: Use default coordinates.', 0