[BITS 32]
global _start
global problem

CODE_SEG equ 0x08
DATA_SEG equ 0x10

extern kernel_main

_start:
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax
    mov ebp, 0x00200000
    mov esp, ebp

    ; Enable the A20 line
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Remap the Master PIC 
    mov al , 00010001b
    out 0x20 , al   ; tell master PIC

    mov al , 0x20
    out 0x21 , al   ; Interrupt 0x20 is where the master PIC(IRQ 0-7) should start

    mov al , 00000001b
    out 0x21 , al   
    ; End of Remap the master PIC


    call kernel_main
    jmp $

times 512-($ - $$) db 0