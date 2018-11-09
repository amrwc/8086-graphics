%include "graphics_ellipse_main.asm"
%include "graphics_ellipse_algorithm.asm"

Graphics_Ellipse:
    push    word 100d ; x0              ; Default rectangle (edges of ellipse)
    push    word 50d  ; y0
    push    word 115d ; x1
    push    word 60d  ; y1
    call    Graphics_Ellipse_Main

    ret

; This solution is limited by 16 bit address space. Every multiplication
; being made inside of the algorithm, stores the result in DX:AX registers.
; Therefore, it is not possible to later multiply DX:AX again with
; the current solution. This results in a horrible errors while drawing
; the ellipse. The option 1 shows the right output. Option 2 shows
; an example of an erroneuos output. 