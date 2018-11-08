ORG 9000h
    jmp    Stage_1_Start

%include "print_functions_16.asm"
%include "graphics_line.asm"
%include "graphics_colour_menu.asm"

; Assignment Stage 1 -- draw a line using Bresenham’s algorithm.
Stage_1_Start:
    mov     si, horizontal_line
    call    Console_WriteLine_16
    call    New_Line_16

    call    Graphics_Line

;____________________
Halt:
    mov     ax, 0003h                   ; Clear screen
    int     10h
    mov     si, goodbye_message
    call    Console_Write_16
    hlt

;____________________
; Data
horizontal_line: db '____________________', 0
goodbye_message: db 'Goodbye!', 0

;____________________
    times 3584 - ($ - $$) db 0