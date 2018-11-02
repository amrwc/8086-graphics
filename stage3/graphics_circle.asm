%include "graphics_circle_main.asm"
%include "graphics_circle_algorithm.asm"

Graphics_Circle:
    push    130d   ; xm                 ; Default arguments: X-middle
    push    110d   ; ym                 ;                    Y-middle
    push    50d    ; r                  ;                    radius
    push    0d     ; px_set placeholder
    call    Graphics_Circle_Main

    ret