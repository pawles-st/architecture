section .text
global _start

_start:
	mov eax, 0
	mov ebx, 78
	mov edx, 0
	mov esi, 22
	mov ecx, 1

countbits:
	cmp ecx, ebx
	jg fixecx
	shl ecx, 1
	jmp countbits

fixecx:
	shr ecx, 1

nextdigit:
	cmp ecx, 0
	je quit
	shl edx, 1
	push eax
	mov eax, ebx
	and eax, ecx
	jz noadd
	add edx, 1

noadd:
	pop eax
	shr ecx, 1

checksub:
	cmp edx, esi
	jle addzero
	sub edx, esi
	jmp addone

addzero:
	shl eax, 1
	jmp nextdigit

addone:
	shl eax, 1
	add eax, 1
	jmp nextdigit

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
	mov esi, 0
	mov esi, 0
	mov esi, 0
	mov esi, 0
	mov eax, 1
	mov ebx, 0
	int 80h
