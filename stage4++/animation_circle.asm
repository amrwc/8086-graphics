%assign circ_xm 8
%assign circ_ym 6
%assign circ_r  4

%assign x   2
%assign y   4
%assign err 6

%include "animation_circle_q1.asm"
%include "animation_circle_q2.asm"
%include "animation_circle_q3.asm"
%include "animation_circle_q4.asm"
%include "animation_circle_finish.asm"

Animation_Circle:
    call    Graphics_Set_Display_Mode

    push    word 130d  ; xm
    push    word 110d  ; ym
    push    word 50d   ; r
    call    Animation_Circle_Q4

    push    word 130d
    push    word 110d
    push    word 50d
    call    Animation_Circle_Q1

    push    word 130d
    push    word 110d
    push    word 50d
    call    Animation_Circle_Q2

    push    word 130d
    push    word 110d
    push    word 50d
    call    Animation_Circle_Q3

    push    word 130d
    push    word 110d
    push    word 50d
    call    Animation_Circle_Finish

    push    word 0
    push    word 24d
    push    word press_any_key
    call    Console_Write_16_Graphics

    call    Graphics_Done
    ret