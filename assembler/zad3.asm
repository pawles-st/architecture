section .text
global _start

_start:
	mov bx, 1234		; input number
	mov ax, 0			; BCD representation

lower:
	push ax
	mov ax, bx
	mov si, 100
	mov dx, 0
	idiv si				; shift the nibble to the lower one
	mov bx, ax
	pop ax
	push dx

loopl:
	cmp bx, 0
	je higher
	dec bx
	inc ax
	daa
	jmp loopl

higher:
	shl ax, 8
	pop dx
	mov bx, dx

looph:
	cmp bx, 0
	je quit
	dec bx
	inc ax
	daa
	jmp looph

quit:
	mov esi, 0
	mov esi, 0
	mov esi, 0
	mov esi, 0
	mov esi, 0
	mov esi, 0
	mov esi, 0
	mov esi, 0
	mov esi, 0
	mov eax, 1
	mov ebx, 0
	int 80h;
