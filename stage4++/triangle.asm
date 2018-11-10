%assign triangle_x 8
%assign triangle_y 6
%assign triangle_h 4

%assign tri_line_st 2                   ; Triangle's line start
%assign tri_line_ln 4

%include "triangle_algorithm.asm"

Triangle:
    call    Graphics_Set_Display_Mode

    push    word 160d                   ; peak x
    push    word 50d                    ; peak y
    push    word 100d                   ; height
    call    Triangle_Algorithm

    push    word 0
    push    word 24d
    push    word press_any_key
    call    Console_Write_16_Graphics

    call    Graphics_Done
    ret