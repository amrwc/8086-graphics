%assign px_set  4

Graphics_Colour_Menu:
    push    bp
    mov     bp, sp
    push    ax

    mov     ax, 0003h                   ; Clear screen
    int     10h

    call    Colour_Menu

;____________________
colour_menu_get_key:
    xor     ah, ah                      ; Get a keystroke
    int     16h

    cmp     ah, 01h                     ; exit
    jne     colour_menu_check_key
    call    Halt

colour_menu_check_key:
    cmp     ah, 08h
    jg      colour_menu_get_key

    add     ah, 7d                      ; Assign colour
    mov     al, ah
    mov     ah, 0Ch
    mov     [bp + px_set], ax

    pop     ax
    leave
    ret

;____________________
Colour_Menu:
    push    word graphics_colour_menu_prompt
    call    Console_WriteLine_16

    push    word graphics_colour_menu_prompt_colour1
    call    Console_WriteLine_16
    push    word graphics_colour_menu_prompt_colour2
    call    Console_WriteLine_16
    push    word graphics_colour_menu_prompt_colour3
    call    Console_WriteLine_16
    push    word graphics_colour_menu_prompt_colour4
    call    Console_WriteLine_16
    push    word graphics_colour_menu_prompt_colour5
    call    Console_WriteLine_16
    push    word graphics_colour_menu_prompt_colour6
    call    Console_WriteLine_16
    push    word graphics_colour_menu_prompt_colour7
    call    Console_WriteLine_16

    call    New_Line_16
    push    word graphics_menu_prompt_exit
    call    Console_WriteLine_16

    ret

;____________________
; Data
graphics_colour_menu_prompt: db 'Choose a colour:', 0
graphics_colour_menu_prompt_colour1: db '1: Light blue', 0
graphics_colour_menu_prompt_colour2: db '2: Light green', 0
graphics_colour_menu_prompt_colour3: db '3: Light cyan', 0
graphics_colour_menu_prompt_colour4: db '4: Light red', 0
graphics_colour_menu_prompt_colour5: db '5: Light magenta', 0
graphics_colour_menu_prompt_colour6: db '6: Yellow', 0
graphics_colour_menu_prompt_colour7: db '7: White', 0