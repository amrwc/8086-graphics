%include "graphics_rectangle_main.asm"
%include "graphics_rectangle_algorithm.asm"

Graphics_Rectangle:
    push    50d    ; x0                 ; Default arguments
    push    50d    ; y0
    push    100d   ; width
    push    100d   ; height
    push    0d     ; pixel settings placeholder
    call    Graphics_Rectangle_Main

    ret