%include "graphics_circle_main.asm"
%include "graphics_circle_algorithm.asm"

Graphics_Circle:
    push    word 130d ; xm              ; Def args: X-centre
    push    word 110d ; ym              ;           Y-centre
    push    word 50d  ; r               ;           radius
    call    Graphics_Circle_Main

    ret