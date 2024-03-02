; nasm -f elf zad3.asm
; ld -m elf_i386 zad3.o -o zad3
; ./zad3

%include        'functions.asm'

section .text

global _start

_start:

    mov     eax, 4321
    call    iprintLF
    call    decToBCD
    
    mov     eax, 275
    call    iprintLF
    call    decToBCD

    mov     eax, 9999
    call    iprintLF
    call    decToBCD

    mov     eax, 0
    call    iprintLF
    call    decToBCD
    
    call    quit

decToBCD:
    push    edx
    mov     esi, 1000

digitLoop:    
    idiv    esi				; 
    call    printBCD
    push    edx
    push    eax
    mov     eax, esi
    mov     edx, 0
    mov     esi, 10
    idiv    esi
    mov     esi, eax
    pop     eax
    pop     edx
    mov     eax, edx
    mov     edx, 0
    cmp     esi, 1
    jne     digitLoop

    call    printBCD
    push    eax
    mov     eax, 0AH        ; nowa linia
    push    eax
    mov     eax, esp
    call    sprint
    pop     eax
    pop     eax

    pop     edx
    ret

printBCD:
    push    esi
    push    eax
    push    edx
    mov     esi, 8

BCDLoop:
    mov     edx, 0
    idiv    esi
    call    iprint

    ; push    edx
    ; mov     edx, 0
    ; mov     eax, esi
    ; mov     esi, 2
    ; idiv    esi
    ; mov     esi, eax
    ; pop     edx

    shr     esi, 1

    mov     eax, edx
    cmp     esi, 1
    jne     BCDLoop

    call    iprint
    mov     eax, 20h        ; spacja
    push    eax
    mov     eax, esp
    call    sprint
    pop     eax
    pop     edx
    pop     eax
    pop     esi
    ret
