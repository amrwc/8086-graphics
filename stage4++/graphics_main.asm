%include "animation_circle.asm"
%include "print_functions_graphics.asm"

Graphics_Main:
    call    Graphics_Main_Menu

;____________________
main_menu_get_key:
    xor     ah, ah                      ; Get a keystroke
    int     16h

    cmp     ah, 01h                     ; exit
    jne     main_menu_option1
    ret

main_menu_option1:
    cmp     ah, 02h
    jne     main_menu_get_key
    call    Animation_Circle
    jmp     Graphics_Main

;____________________
Graphics_Set_Display_Mode:
    push    ax

    mov     ax, 0013h                   ; Set display mode to 320x200px, 256 colours, 1 page.
    int     10h

    pop     ax
    ret

;____________________
Graphics_Done:
    push    ax

    xor     ax, ax                      ; getchar()
    int     16h
    mov     ax, 0003h                   ; Return to text mode
    int     10h

    pop     ax
    ret

;____________________
Graphics_Main_Menu:
    push    word graphics_line_menu_greeting
    call    Console_WriteLine_16
    call    New_Line_16
    push    word graphics_main_menu_prompt
    call    Console_WriteLine_16

    push    word graphics_main_menu_option1
    call    Console_WriteLine_16

    call    New_Line_16
    push    word graphics_menu_prompt_exit
    call    Console_WriteLine_16

    ret

;____________________
; Data
graphics_line_menu_greeting: db 'Stage 4++: Features that did not fit in Stage 4.', 0
graphics_main_menu_prompt: db 'Choose one of the options below:', 0
graphics_main_menu_option1: db '1: Circle animation', 0
graphics_menu_prompt_exit: db 'Press (ESC) to exit the program.', 0

press_any_key: db 'Press any key to return...', 0