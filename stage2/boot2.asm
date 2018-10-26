ORG 9000h
    jmp    Stage_2_Start

%include "print_functions_16.asm"
%include "graphics_line.asm"

Stage_2_Start:
    mov     si, horizontal_line
    call    Console_WriteLine_16
    call    New_Line_16


; Assignment Stage 1 -- draw a line using Bresenham’s algorithm.
    call    Graphics_Line

;____________________
Halt:
    mov     si, goodbye_message
    call    Console_Write_16
    hlt

;____________________
; Data
horizontal_line: db '____________________', 0
goodbye_message: db 'Goodbye!', 0

;____________________
    times 3584 - ($ - $$) db 0