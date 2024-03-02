section .text
global _start

_start:
	mov eax, 0
	mov ebx, 12
	mov edx, 34
	jmp addloop

addloop:
	push edx
	and edx, 1
	jz nextdigit
	add eax, ebx
	jmp nextdigit

nextdigit:
	pop edx
	shr edx, 1
	shl eax, 1
	cmp edx, 0
	je quit
	jmp addloop

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
	mov esi, 0
	mov esi, 0
	mov esi, 0
	mov esi, 0
	mov eax, 1
	mov ebx, 0
	int 80h
