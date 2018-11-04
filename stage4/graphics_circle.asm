%include "graphics_circle_main.asm"
%include "graphics_circle_algorithm.asm"

Graphics_Circle:
    push    130d   ; xm                 ; Def args: X-centre
    push    110d   ; ym                 ;           Y-centre
    push    50d    ; r                  ;           radius
    push    0d     ; px_set placeholder
    call    Graphics_Circle_Main

    ret