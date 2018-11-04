%include "graphics_line_main.asm"
%include "graphics_line_bresenham.asm"

Graphics_Line:
    push    27d     ; x0                ; Default arguments
    push    170d    ; y0
    push    300d    ; x1
    push    170d    ; y1
    call    Graphics_Line_Main

    ret

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
; Data
graphics_menu_prompt_exit: db 'Press (ESC) to exit the program.', 0