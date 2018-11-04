; Input:
; xm: [bp + 10] -> [bp + circ_xm]
; ym: [bp + 8]  -> [bp + circ_ym]
;  r: [bp + 6]  -> [bp + circ_r]
; px: [bp + 4]  -> [bp + px_set]

%assign circ_xm 10
%assign circ_ym 8
%assign circ_r  6
%assign px_set  4

Graphics_Circle_Main:
    push    bp
    mov     bp, sp
    push    ax

    call    Graphics_Circle_Menu

;____________________
circle_menu_get_key:
    xor     ah, ah                      ; Get a keystroke
    int     16h

    cmp     ah, 01h                     ; exit
    jne     circle_menu_option1
    call    Halt

circle_menu_option1:
    cmp     ah, 02h
    jne     circle_menu_option2
    mov     [bp + circ_xm], word 50d
    mov     [bp + circ_ym], word 50d
    mov     [bp + circ_r], word 25d
    jmp     end_circle_menu

circle_menu_option2:
    cmp     ah, 03h
    jne     circle_menu_option3
    mov     [bp + circ_xm], word 170d
    mov     [bp + circ_ym], word 80d
    mov     [bp + circ_r], word 37d
    jmp     end_circle_menu

circle_menu_option3:
    cmp     ah, 04h
    jne     circle_menu_option4
    mov     [bp + circ_xm], word 250d
    mov     [bp + circ_ym], word 140d
    mov     [bp + circ_r], word 55d
    jmp     end_circle_menu

circle_menu_option4:
    cmp     ah, 05h
    jne     circle_menu_option5
    mov     [bp + circ_xm], word 32d
    mov     [bp + circ_ym], word 166d
    mov     [bp + circ_r], word -21d
    jmp     end_circle_menu

circle_menu_option5:
    cmp     ah, 06h
    jne     circle_menu_option6

    call    Graphics_Set_Display_Mode

    push    word 50d    ; xm
    push    word 50d    ; ym
    push    word 25d    ; r
    push    word 0C0Ah  ; px_set
    call    Graphics_Circle_Algorithm

    push    word 170d
    push    word 80d
    push    word 37d
    push    word 0C0Ch
    call    Graphics_Circle_Algorithm

    push    word 250d
    push    word 140d
    push    word 55d
    push    word 0C0Eh
    call    Graphics_Circle_Algorithm

    push    word 32d
    push    word 166d
    push    word 21d
    push    word 0C0Fh
    call    Graphics_Circle_Algorithm

    call    Graphics_Done               ; Skip colour menu.
    mov     ax, 0003h
    int     10h

    pop     ax
    leave
    ret 8
    
circle_menu_option6:                    ; Use default coordinates
    cmp     ah, 07h
    jne     circle_menu_get_key

;____________________
end_circle_menu:
    push    word [bp + circ_xm]
    push    word [bp + circ_ym]
    push    word [bp + circ_r]
    push    word 0C00h                  ; Default pixel settings.

    call    Graphics_Colour_Menu
    call    Graphics_Set_Display_Mode
    call    Graphics_Circle_Algorithm
    call    Graphics_Done

    pop     ax
    leave
    ret 8

;____________________
Graphics_Circle_Menu:
    mov     ax, 0003h                   ; Clear screen
    int     10h

    push    word graphics_circle_menu_prompt
    call    Console_WriteLine_16

    push    word graphics_circle_menu_option1
    call    Console_WriteLine_16
    push    word graphics_circle_menu_option2
    call    Console_WriteLine_16
    push    word graphics_circle_menu_option3
    call    Console_WriteLine_16
    push    word graphics_circle_menu_option4
    call    Console_WriteLine_16
    push    word graphics_circle_menu_option5
    call    Console_WriteLine_16
    push    word graphics_circle_menu_option6
    call    Console_WriteLine_16

    call    New_Line_16
    push    word graphics_menu_prompt_exit
    call    Console_WriteLine_16

    ret

;____________________
; Data
graphics_circle_menu_prompt: db 'Choose one of the options below:', 0
graphics_circle_menu_option1: db '1: (50, 50), r = 25', 0
graphics_circle_menu_option2: db '2: (170, 80), r = 37', 0
graphics_circle_menu_option3: db '3: (250, 140) r = 55', 0
graphics_circle_menu_option4: db '4: (32, 166) r = -21', 0
graphics_circle_menu_option5: db '5: Draw all of the above.', 0
graphics_circle_menu_option6: db '6: Use default coordinates.', 0