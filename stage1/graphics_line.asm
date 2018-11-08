%include "graphics_line_main.asm"
%include "graphics_line_bresenham.asm"

Graphics_Line:
    mov     [x0], word 27d              ; DEFAULT COORDINATES
    mov     [y0], word 170d             ; This stage uses labels, therefore
    mov     [x1], word 300d             ; these values are only guaranteed
    mov     [y1], word 170d             ; to work on the first run.
    call    Graphics_Line_Main

    ret

;____________________
Graphics_Done:
    xor     ax, ax                      ; getchar()
    int     16h

    mov     ax, 0003h                   ; Return to text mode
    int     10h
    ret

;____________________
Graphics_Set_Display_Mode:
    mov     ax, 0013h                   ; Set display mode to 320x200px, 256 colours, 1 page.
    int     10h
    ret

Graphics_Setup:
    mov     cx, word [x0]               ; Column start
    mov     dx, word [y0]               ; Row start
    mov     al, byte [pixel_colour]
    mov     ah, 0Ch                     ; Draw pixel instruction
    ret

;____________________
; Data
    x0: dw 0                            ; Line start
    y0: dw 0
    x1: dw 0                            ; Line end
    y1: dw 0

    pixel_colour: db 0

graphics_menu_prompt_exit: db 'Press (ESC) to leave Line Drawing', 0