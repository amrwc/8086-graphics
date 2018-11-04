%include "graphics_rectangle_main.asm"
%include "graphics_rectangle_algorithm.asm"

Graphics_Rectangle:
    push    word 50d    ; x0            ; Default arguments
    push    word 50d    ; y0
    push    word 140d   ; width
    push    word 100d   ; height
    push    word 0d     ; pixel settings placeholder
    call    Graphics_Rectangle_Main

    ret