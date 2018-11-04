; Input:
; x0: [bp + 12] -> [bp + rect_x0]
; y0: [bp + 10] -> [bp + rect_y0]
;  w: [bp + 8]  -> [bp + rect_w]
;  h: [bp + 6]  -> [bp + rect_h]
; px: [bp + 4]  -> [bp + px_set]

%assign circ_next_row 2

%include "graphics_rectangle_test_dimensions.asm"
%include "graphics_rectangle_test_boundaries.asm"

Graphics_Rectangle_Algorithm:
    push    bp
    mov     bp, sp
    sub     sp, 2
    push    es
    push    di
    push    si
    push    ax
    push    cx
    push    dx

;____________________
; Setup
    call    Graphics_Rectangle_Test_Dimensions
    call    Graphics_Rectangle_Test_Boundaries

    mov     si, 0A000h                  ; Segment of display memory
    mov     es, si

; Offset on screen: di = 320*y + x -> di = 256*y + 64*y + x
    mov     di, [bp + rect_y0]
    shl     di, 8                       ; di *= 2**8 -> di *= 256
    mov     si, [bp + rect_y0]
    shl     si, 6                       ; si *= 2**6 -> si *= 64
    add     di, si                      ; di = 256y + 64y
    add     di, [bp + rect_x0]          ; di += x

    mov     si, 320d                    ; Row incrementer
    sub     si, [bp + rect_w]
    mov     [bp - circ_next_row], si

    mov     ax, [bp + px_set]           ; Colour
    xor     si, si                      ; Loop index

    cld                                 ; Clear direction flag -- stos increments CX by 1

Draw_Rectangle_Repeat:
    mov     cx, [bp + rect_w]           ; Reset the counter.
    rep     stosb                       ; Place AL (colour byte) at DI (screen offset).
    add     di, [bp - circ_next_row]    ; Go to the next row.

    inc     si
    cmp     si, word [bp + rect_h]      ; if (SI > height) break;
    jl      Draw_Rectangle_Repeat

;____________________
; Return
    pop     dx
    pop     cx
    pop     ax
    pop     si
    pop     di
    pop     es
    leave
    ret 10