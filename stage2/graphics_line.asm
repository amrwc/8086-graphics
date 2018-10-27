; Default coordinates can be set in graphics_line_main.asm

%include "graphics_line_main.asm"
%include "graphics_line_colour_menu.asm"
%include "graphics_line_test_boundaries.asm"
%include "graphics_line_test_straight.asm"

%include "graphics_line_bresenham.asm"

Graphics_Line:
    push    170d    ; y1                ; Default arguments
    push    300d    ; x1
    push    170d    ; y0
    push    27d     ; x0
    call    Graphics_Line_Main

    jmp     Graphics_Line

;____________________
Graphics_Done:
    push    bp
    mov     bp, sp
    push    ax

    xor     ax, ax                      ; getchar()
    int     16h
    mov     ax, 0003h                   ; Return to text mode
    int     10h

    pop     ax
    leave
    ret

;____________________
Graphics_Set_Display_Mode:
    push    bp
    mov     bp, sp
    push    ax

    mov     ax, 0013h                   ; Set display mode to 320x200px, 256 colours, 1 page.
    int     10h

    pop     ax
    leave
    ret

Graphics_Setup:
    mov     cx, word [bp + x0]          ; Column start
    mov     dx, word [bp + y0]          ; Row start
    mov     al, byte [pixel_colour]
    mov     ah, 0Ch                     ; Draw pixel instruction
    ret

;____________________
; Data
    pixel_colour: db 0

graphics_line_menu_prompt_exit: db 'Press (ESC) to exit the program.', 0