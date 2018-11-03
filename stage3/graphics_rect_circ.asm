; Vitruvian Man drawing
Graphics_Rect_Circ:
    push    ax

    call    Graphics_Set_Display_Mode

    push    word 100d   ; x0
    push    word 40d    ; y0
    push    word 120d   ; w
    push    word 120d   ; h
    push    word 0C09h  ; px_set
    call    Graphics_Rectangle_Algorithm

    push    word 160d   ; xm
    push    word 88d    ; ym
    push    word 72d    ; r
    push    word 0C0Eh  ; px_set
    call    Graphics_Circle_Algorithm

    call    Graphics_Done
    mov     ax, 0003h
    int     10h

    pop     ax
    ret