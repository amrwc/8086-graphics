%include "graphics_rectangle.asm"
%include "graphics_circle.asm"
%include "graphics_rect_circ.asm"
%include "graphics_ellipse.asm"
%include "graphics_colour_menu.asm"

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
    jne     main_menu_option2
    call    Graphics_Rectangle
    jmp     Graphics_Main

main_menu_option2:
    cmp     ah, 03h
    jne     main_menu_option3
    call    Graphics_Circle
    jmp     Graphics_Main

main_menu_option3:
    cmp     ah, 04h
    jne     main_menu_option4
    call    Graphics_Rect_Circ
    jmp     Graphics_Main

main_menu_option4:
    cmp     ah, 05h
    jne     main_menu_get_key
    call    Graphics_Ellipse
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
    push    word graphics_main_menu_option2
    call    Console_WriteLine_16
    push    word graphics_main_menu_option3
    call    Console_WriteLine_16
    push    word graphics_main_menu_option4
    call    Console_WriteLine_16

    call    New_Line_16
    push    word graphics_menu_prompt_exit
    call    Console_WriteLine_16

    ret

;____________________
; Data
graphics_line_menu_greeting: db 'Stage 4: Rectangle and circle drawing algorithms implementations using direct writing to VRAM.', 0
graphics_main_menu_prompt: db 'Choose a shape:', 0
graphics_main_menu_option1: db '1: Rectangle', 0
graphics_main_menu_option2: db '2: Circle', 0
graphics_main_menu_option3: db '3: Both a rectangle and a circle -- Vitruvian Man', 0
graphics_main_menu_option4: db '4: Ellipse', 0
graphics_menu_prompt_exit: db 'Press (ESC) to exit the program.', 0