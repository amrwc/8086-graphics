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
Graphics_Set_Display_Mode:
    push    bp
    mov     bp, sp
    push    ax

    mov     ax, 0013h                   ; Set display mode to 320x200px, 256 colours, 1 page.
    int     10h

    pop     ax
    leave
    ret

;____________________
Graphics_Setup:
    mov     cx, word [bp + x0]          ; Column start
    mov     dx, word [bp + y0]          ; Row start
    mov     ax, word [bp + px_set]      ; AH: 0Ch, AL: colour
    ret

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
; Data
graphics_line_menu_prompt_exit: db 'Press (ESC) to exit the program.', 0