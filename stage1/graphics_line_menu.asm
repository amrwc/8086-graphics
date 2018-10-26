Graphics_Line_Menu:
    mov     si, graphics_line_prompt
    call    Console_WriteLine_16

    mov     si, graphics_line_prompt_colour1
    call    Console_WriteLine_16
    mov     si, graphics_line_prompt_colour2
    call    Console_WriteLine_16
    mov     si, graphics_line_prompt_colour3
    call    Console_WriteLine_16
    mov     si, graphics_line_prompt_colour4
    call    Console_WriteLine_16
    mov     si, graphics_line_prompt_colour5
    call    Console_WriteLine_16
    mov     si, graphics_line_prompt_colour6
    call    Console_WriteLine_16
    mov     si, graphics_line_prompt_colour7
    call    Console_WriteLine_16

    call    New_Line_16
    mov     si, graphics_line_prompt_exit
    call    Console_WriteLine_16

;____________________
Get_key:
    xor     ah, ah                      ; Get a keystroke
    int     16h

    cmp     ah, 01h                     ; exit
    jne     check_key
    mov     ax, 0003h                   ; Clear screen
    int     10h
    ret

check_key:
    cmp     ah, 08h
    jg      Get_key

assign_colour:
    add     ah, 7d
    mov     [pixel_colour], ah
    jmp     end_menu

;____________________
; Data
graphics_line_prompt: db 'Choose a colour from 1 to 7:', 0
graphics_line_prompt_exit: db 'Press (ESC) to leave Line Drawing', 0
pixel_colour: db 0

graphics_line_prompt_colour1: db '1: Light blue', 0
graphics_line_prompt_colour2: db '2: Light green', 0
graphics_line_prompt_colour3: db '3: Light cyan', 0
graphics_line_prompt_colour4: db '4: Light red', 0
graphics_line_prompt_colour5: db '5: Light magenta', 0
graphics_line_prompt_colour6: db '6: Yellow', 0
graphics_line_prompt_colour7: db '7: White', 0

end_menu: