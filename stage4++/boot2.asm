ORG 9000h
    jmp    Stage_4_Plus_Start

%include "print_functions_16_SF.asm"
%include "graphics_main.asm"

; Assignment Stage 4++ -- additional features that didn't fit in Stage 4.
Stage_4_Plus_Start:
    push    word horizontal_line
    call    Console_WriteLine_16
    call    New_Line_16

    call    Graphics_Main

;____________________
Halt:
    mov     ax, 0003h                   ; Clear screen
    int     10h
    push    word goodbye_message
    call    Console_Write_16
    hlt

;____________________
; Data
horizontal_line: db '____________________', 0
goodbye_message: db 'Goodbye!', 0

;____________________
    times 3584 - ($ - $$) db 0