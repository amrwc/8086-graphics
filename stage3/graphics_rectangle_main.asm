; Input:
; x0: [bp + 4] -> [bp + rect_x0]
; y0: [bp + 6] -> [bp + rect_y0]
; x1: [bp + 8] -> [bp + rect_x1]
; y1: [bp + 10 ] -> [bp + rect_y1]

%assign rect_x0  4
%assign rect_y0  6
%assign rect_x1  8
%assign rect_y1  10
%assign px_set   12

Graphics_Rectangle_Main:
    push	bp
	mov		bp, sp
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
    mov     [bp + rect_x1], word 100d
    mov     [bp + rect_y1], word 60d
    jmp     end_rectangle_menu

rectangle_menu_option2:
    cmp     ah, 03h
    jne     rectangle_menu_option3
    mov     [bp + rect_x0], word 200d
    mov     [bp + rect_y0], word 15d
    mov     [bp + rect_x1], word 230d
    mov     [bp + rect_y1], word 80d
    jmp     end_rectangle_menu

rectangle_menu_option3:
    cmp     ah, 04h
    jne     rectangle_menu_option4
    mov     [bp + rect_x0], word 300d
    mov     [bp + rect_y0], word 160d
    mov     [bp + rect_x1], word 200d
    mov     [bp + rect_y1], word 195d
    jmp     end_rectangle_menu

rectangle_menu_option4:
    cmp     ah, 05h
    jne     rectangle_menu_option5
    mov     [bp + rect_x0], word 107d
    mov     [bp + rect_y0], word 175d
    mov     [bp + rect_x1], word 32d
    mov     [bp + rect_y1], word 144d
    jmp     end_rectangle_menu

rectangle_menu_option5:
    cmp     ah, 06h
    jne     rectangle_menu_option6

    call    Graphics_Set_Display_Mode

    push    word 0C0Ah
    push    word 60d
    push    word 100d
    push    word 20d
    push    word 50d
    call    Graphics_Rectangle_Algorithm

    push    word 0C0Ch
    push    word 80d
    push    word 230d
    push    word 15d
    push    word 200d
    call    Graphics_Rectangle_Algorithm

    push    word 0C0Eh
    push    word 195d
    push    word 200d
    push    word 160d
    push    word 300d
    call    Graphics_Rectangle_Algorithm

    push    word 0C0Fh
    push    word 144d
    push    word 32d
    push    word 175d
    push    word 107d
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
    mov     ax, 0003h
    int     10h

    push    word 0C00h                  ; Default pixel settings. Push for easier colour setup in subsequent menu.
    push    word [bp + rect_y1]
    push    word [bp + rect_x1]
    push    word [bp + rect_y0]
    push    word [bp + rect_x0]

    call    Graphics_Colour_Menu
    call    Graphics_Rectangle_Algorithm
    call    Graphics_Done

    pop     ax
    leave
    ret 8

;____________________
Graphics_Rectangle_Menu:
    push    bp
    mov     bp, sp
    push    si

    mov     si, graphics_rectangle_menu_prompt
    call    Console_WriteLine_16

    mov     si, graphics_rectangle_menu_option1
    call    Console_WriteLine_16
    mov     si, graphics_rectangle_menu_option2
    call    Console_WriteLine_16
    mov     si, graphics_rectangle_menu_option3
    call    Console_WriteLine_16
    mov     si, graphics_rectangle_menu_option4
    call    Console_WriteLine_16
    mov     si, graphics_rectangle_menu_option5
    call    Console_WriteLine_16
    mov     si, graphics_rectangle_menu_option6
    call    Console_WriteLine_16

    call    New_Line_16
    mov     si, graphics_menu_prompt_exit
    call    Console_WriteLine_16

    pop     si
    leave
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