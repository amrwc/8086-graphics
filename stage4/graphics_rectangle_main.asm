; Input:
; x0: [bp + 12] -> [bp + rect_x0]
; y0: [bp + 10] -> [bp + rect_y0]
;  w: [bp + 8]  -> [bp + rect_w]
;  h: [bp + 6]  -> [bp + rect_h]

%assign rect_x0 10
%assign rect_y0 8
%assign rect_w  6
%assign rect_h  4

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
    mov     [bp + rect_x0], word 50d
    mov     [bp + rect_y0], word 20d
    mov     [bp + rect_w], word 50d
    mov     [bp + rect_h], word 40d
    jmp     end_rectangle_menu

rectangle_menu_option2:
    cmp     ah, 03h
    jne     rectangle_menu_option3
    mov     [bp + rect_x0], word 200d
    mov     [bp + rect_y0], word 15d
    mov     [bp + rect_w], word 30d
    mov     [bp + rect_h], word 65d
    jmp     end_rectangle_menu

rectangle_menu_option3:
    cmp     ah, 04h
    jne     rectangle_menu_option4
    mov     [bp + rect_x0], word 200d
    mov     [bp + rect_y0], word 160d
    mov     [bp + rect_w], word 100d
    mov     [bp + rect_h], word 35d
    jmp     end_rectangle_menu

rectangle_menu_option4:
    cmp     ah, 05h
    jne     rectangle_menu_option5
    mov     [bp + rect_x0], word 32d
    mov     [bp + rect_y0], word 144d
    mov     [bp + rect_w], word 75d
    mov     [bp + rect_h], word 31d
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

    push    word 32d
    push    word 144d
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

;____________________
end_rectangle_menu:
    push    word [bp + rect_x0]
    push    word [bp + rect_y0]
    push    word [bp + rect_w]
    push    word [bp + rect_h]
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
graphics_rectangle_menu_option1: db '1: (50, 20) -> (100, 60)', 0
graphics_rectangle_menu_option2: db '2: (200, 15) -> (230, 80)', 0
graphics_rectangle_menu_option3: db '3: (300, 160) -> (200, 195)', 0
graphics_rectangle_menu_option4: db '4: (107, 175) -> (32, 144)', 0
graphics_rectangle_menu_option5: db '5: Draw all of the above.', 0
graphics_rectangle_menu_option6: db '6: Use default coordinates.', 0