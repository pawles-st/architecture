section .text
global _start

_start:
	mov ax, 0			; BCD representation
	mov bx, 15			; number to change to BCD
	mov cx, 0			; loop counter
	mov si, 1			; currently extracted bit
	jmp bcdloop

bcdloop:
	cmp cx, 4			; finish?
	je quit				; yes, quit
	inc cx				; no, increment counter for next iteration

	push bx				; store bx on stack
	and bx, si			; extract current bit of bx
	add ax, bx			; add bit value to bcd...
	daa					; ...and fix bcd representation
	pop bx				; restore bx
	shl	si, 1			; change bit to the next one
	jmp bcdloop

	;shr ax
	;inc ecx

digitadd:



	mov al, 0
	mov bl, 10
	add al, bl
	daa
	add al, bl
	daa
	mov esi, 1

quit:
	mov eax, 1
	mov ebx, 0
	int 80h;
