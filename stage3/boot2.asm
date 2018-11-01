ORG 9000h
    jmp    Stage_3_Start

%include "print_functions_16.asm"
%include "graphics_rectangle.asm"

Stage_3_Start:
    mov     si, horizontal_line
    call    Console_WriteLine_16
    call    New_Line_16

; Assignment Stage 3 -- draw a rectangle and a circle.
    call    Graphics_Rectangle

;____________________
Halt:
    mov     ax, 0003h                   ; Clear screen
    int     10h
    mov     si, goodbye_message
    call    Console_Write_16
    hlt

;____________________
Graphics_Set_Display_Mode:
    push    bp
    mov     bp, sp
    push    ax

    mov     ax, 0013h                   ; Set display mode to 320x200px, 256 colours, 1 page.
    int     10h

    pop     ax
    leave
    ret

;____________________
Graphics_Done:
    push    bp
    mov     bp, sp
    push    ax

    xor     ax, ax                      ; getchar()
    int     16h
    mov     ax, 0003h                   ; Return to text mode
    int     10h

    pop     ax
    leave
    ret

;____________________
; Data
horizontal_line: db '____________________', 0
graphics_menu_prompt_exit: db 'Press (ESC) to exit the program.', 0
goodbye_message: db 'Goodbye!', 0

;____________________
    times 3584 - ($ - $$) db 0