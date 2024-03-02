SETCURSOR:
	mov ah, 02
	mov bh, 00
	mov dh, 12
	mov dl, 25
	int 10h

CLSCREEN:
	mov ah, 0600h
	mov bh, 07
	mov cx, 0
	mov dx, 184fh
	int 10h

	lea di, Screen
	mov dword ptr [CntrA], -510*256
	mov word ptr [X], 0

@@LoopHoriz:
	mov dword ptr [CntrB], -270*256
	mov word ptr [Y], 200

@@LoopVert:
	xor ecx, ecx
	xor edx, edx
	mov si, 32-1

@@LoopFractal:
	mov eax, ecx
	imul eax, eax
	mov ebx, edx
	imul ebx, ebx
	sub eax, ebx
	add eax, dword ptr [CntrA]
	mov ebx, ecx
	imul ebx, edx
	sal ebx, 1
	add ebx, dword ptr [CntrB]
	sar eax, 8
	sar ebx, 8
	mov ecx, eax
	mov edx, ebx
	imul eax, eax
	imul ebx, ebx
	add eax, ebx
	sar eax, 8
	cmp eax, 1024
	jg Break
	dec si
	jnz @@LoopFractal

Break:
	mov ax, si
	mov byte ptr [di], al
	add dword ptr [CntrB], 720
	add di, 320
	dec word ptr [Y]
	jnz @@LoopVert
	add dword ptr [CntrA], 568
	inc word ptr [X]
	lea di, Screen
	add di, word ptr [X]
	cmp word ptr [X], 320
	jnz @@LoopHoriz
	ret
