; nasm -f elf zad1.asm
; ld -m elf_i386 zad3.o -o zad1
; ./zad1

%include        'functions.asm'

section .text

global _start

_start:

    mov     eax, 17
    call    decToHex

    mov     eax, 256
    call    decToHex

    mov     eax, 123456
    call    decToHex

    mov     eax, 1234567890
    call    decToHex

    mov     eax, 2147483648
    call    decToHex

    mov     eax, 4294967295
    call    decToHex

    call    quit

decToHex:
    push    eax
    push    ecx
    push    edx
    push    esi
    mov     ecx, 0

divideLoopDecToHex:
    inc     ecx
    mov     edx, 0
    mov     esi, 16
    idiv    esi
    cmp     edx, 9
    jg      letters

digits:
    add     edx, 48
    push    edx
    cmp     eax, 0
    jnz     divideLoopDecToHex
    jmp     printLoopDecToHex

letters:
    add     edx, 55
    push    edx
    cmp     eax, 0
    jnz     divideLoopDecToHex
    ; jmp     printLoopDecToHex

printLoopDecToHex:
    dec     ecx
    mov     eax, esp
    call    sprint
    pop     eax
    cmp     ecx, 0
    jnz     printLoopDecToHex

    ;push    eax
    mov     eax, 0Ah
    push    eax
    mov     eax, esp
    call    sprint
    pop     eax
    ;pop     eax

    pop     esi
    pop     edx
    pop     ecx
    pop     eax
    ret       
