; Input:
; x0: [bp + 12]
; y0: [bp + 10]
;  w: [bp + 8]
;  h: [bp + 6]

Graphics_Rectangle_Main:
    push    bp
    mov     bp, sp
    push    ax

    call    Graphics_Rectangle_Menu

;____________________
rectangle_menu_get_key:
    xor     ah, ah                      ; Get a keystroke
    int     16h

    cmp     ah, 01h                     ; exit
    jne     rectangle_menu_option1
    call    Halt

rectangle_menu_option1:
    cmp     ah, 02h
    jne     rectangle_menu_option2
    push    word 50d    ; x0
    push    word 20d    ; y0
    push    word 50d    ; width
    push    word 40d    ; height
    jmp     end_rectangle_menu

rectangle_menu_option2:
    cmp     ah, 03h
    jne     rectangle_menu_option3
    push    word 200d
    push    word 15d
    push    word 30d
    push    word 65d
    jmp     end_rectangle_menu

rectangle_menu_option3:
    cmp     ah, 04h
    jne     rectangle_menu_option4
    push    word 200d
    push    word 160d
    push    word 100d
    push    word 35d
    jmp     end_rectangle_menu

rectangle_menu_option4:
    cmp     ah, 05h
    jne     rectangle_menu_option5
    push    word -800d
    push    word 999d
    push    word 75d
    push    word 31d
    jmp     end_rectangle_menu

rectangle_menu_option5:
    cmp     ah, 06h
    jne     rectangle_menu_option6

    call    Graphics_Set_Display_Mode

    push    word 50d    ; x0
    push    word 20d    ; y0
    push    word 50d    ; w
    push    word 40d    ; h
    push    word 0C0Ah  ; px_set
    call    Graphics_Rectangle_Algorithm

    push    word 200d
    push    word 15d
    push    word 30d
    push    word 65d
    push    word 0C0Ch
    call    Graphics_Rectangle_Algorithm

    push    word 200d
    push    word 160d
    push    word 100d
    push    word 35d
    push    word 0C0Eh
    call    Graphics_Rectangle_Algorithm

    push    word -800d
    push    word 999d
    push    word 75d
    push    word 31d
    push    word 0C0Fh
    call    Graphics_Rectangle_Algorithm

    call    Graphics_Done               ; Skip colour menu.
    mov     ax, 0003h
    int     10h

    pop     ax
    leave
    ret 8
    
rectangle_menu_option6:                 ; Use default coordinates
    cmp     ah, 07h
    jne     rectangle_menu_get_key
    push    word [bp + 10]
    push    word [bp + 8]
    push    word [bp + 6]
    push    word [bp + 4]

;____________________
end_rectangle_menu:
    push    word 0C00h                  ; Default pixel settings.

    call    Graphics_Colour_Menu
    call    Graphics_Set_Display_Mode
    call    Graphics_Rectangle_Algorithm
    call    Graphics_Done

    pop     ax
    leave
    ret 8

;____________________
Graphics_Rectangle_Menu:
    mov     ax, 0003h                   ; Clear screen
    int     10h

    push    word graphics_rectangle_menu_prompt
    call    Console_WriteLine_16

    push    word graphics_rectangle_menu_option1
    call    Console_WriteLine_16
    push    word graphics_rectangle_menu_option2
    call    Console_WriteLine_16
    push    word graphics_rectangle_menu_option3
    call    Console_WriteLine_16
    push    word graphics_rectangle_menu_option4
    call    Console_WriteLine_16
    push    word graphics_rectangle_menu_option5
    call    Console_WriteLine_16
    push    word graphics_rectangle_menu_option6
    call    Console_WriteLine_16

    call    New_Line_16
    push    word graphics_menu_prompt_exit
    call    Console_WriteLine_16

    ret

;____________________
; Data
graphics_rectangle_menu_prompt: db 'Choose one of the options below:', 0
graphics_rectangle_menu_option1: db '1: (50, 20)    w:50 h:40', 0
graphics_rectangle_menu_option2: db '2: (200, 15)   w:30 h:65', 0
graphics_rectangle_menu_option3: db '3: (200, 160)  w:100 h:35', 0
graphics_rectangle_menu_option4: db '4: (-800, 999) w:75 h:31', 0
graphics_rectangle_menu_option5: db '5: Draw all of the above.', 0
graphics_rectangle_menu_option6: db '6: Use default coordinates.', 0