; Vitruvian Man drawing
; Very close reproduction of the Leonardo da Vinci's drawing from around 1490.
; http://blogs.discovermagazine.com/crux/files/2015/02/vitruvian-man.jpg
Graphics_Rect_Circ:
    push    ax

    call    Graphics_Set_Display_Mode

    push    word 100d   ; x0            ; Background square
    push    word 40d    ; y0
    push    word 121d   ; w
    push    word 121d   ; h
    push    word 0C09h  ; px_set
    call    Graphics_Rectangle_Algorithm

    push    word 160d   ; xm            ; Background circle
    push    word 88d    ; ym
    push    word 72d    ; r
    push    word 0C0Eh  ; px_set
    call    Graphics_Circle_Algorithm

;____________________
    push    word 160d                   ; Head
    push    word 51d
    push    word 11d
    push    word 0C59h
    call    Graphics_Circle_Algorithm

    push    word 156d                   ; Left eye
    push    word 48d
    push    word 1d
    push    word 0C06h
    call    Graphics_Circle_Algorithm

    push    word 164d                   ; Right eye
    push    word 48d
    push    word 1d
    push    word 0C06h
    call    Graphics_Circle_Algorithm

    push    word 160d                   ; Nose
    push    word 50d
    push    word 1d
    push    word 3d
    push    word 0C59h
    call    Graphics_Rectangle_Algorithm

    push    word 161d                   ; Tip of the nose
    push    word 52d
    push    word 1d
    push    word 1d
    push    word 0C59h
    call    Graphics_Rectangle_Algorithm

    push    word 158d                   ; Mouth
    push    word 58d
    push    word 5d
    push    word 1d
    push    word 0C59h
    call    Graphics_Rectangle_Algorithm

    push    word 156d                   ; Neck
    push    word 63d
    push    word 9d
    push    word 3d
    push    word 0C59h
    call    Graphics_Rectangle_Algorithm

;____________________
    push    word 145d                   ; Torso
    push    word 66d
    push    word 31d
    push    word 45d
    push    word 0C59h
    call    Graphics_Rectangle_Algorithm

    push    word 106d                   ; Left arm
    push    word 71d
    push    word 45d
    push    word 2d
    push    word 0C59h
    call    Graphics_Rectangle_Algorithm

    push    word 100d                   ; Left hand
    push    word 69d
    push    word 6d
    push    word 5d
    push    word 0C59h
    call    Graphics_Rectangle_Algorithm

    push    word 171d                   ; Right arm
    push    word 71d
    push    word 44d
    push    word 2d
    push    word 0C59h
    call    Graphics_Rectangle_Algorithm

    push    word 215d                   ; Right hand
    push    word 69d
    push    word 6d
    push    word 5d
    push    word 0C59h
    call    Graphics_Rectangle_Algorithm

;____________________
    push    word 150d                   ; Left leg
    push    word 111d
    push    word 3d
    push    word 50d                    ; Intentionally step on the circle.
    push    word 0C59h
    call    Graphics_Rectangle_Algorithm

    push    word 153d                   ; Left foot
    push    word 159d
    push    word 1d
    push    word 2d
    push    word 0C59h
    call    Graphics_Rectangle_Algorithm

    push    word 168d                   ; Right leg
    push    word 111d
    push    word 3d
    push    word 50d
    push    word 0C59h
    call    Graphics_Rectangle_Algorithm

    push    word 171d                   ; Right knee
    push    word 131d
    push    word 1d
    push    word 3d
    push    word 0C59h
    call    Graphics_Rectangle_Algorithm

    push    word 171d                   ; Right foot
    push    word 158d
    push    word 4d
    push    word 3d
    push    word 0C59h
    call    Graphics_Rectangle_Algorithm

    push    word 175d                   ; Right toe
    push    word 159d
    push    word 4d
    push    word 2d
    push    word 0C59h
    call    Graphics_Rectangle_Algorithm

;____________________
    call    Graphics_Done
    pop     ax
    ret