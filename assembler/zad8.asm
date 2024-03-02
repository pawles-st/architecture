%include 'functions.asm'

section .data

x:		dd	1.5

section .text
global _start

_start:

	; ln(x)

	fldln2					; st0 = ln(2)
	fld dword [x]			; st0 = x, st1 = ln(2)
	fyl2x					; st0 = ln(x)

	; e^x

	fldl2e					; st0 = log_2(e)
	fmul dword [x]			; st0 = log_2(e) * x
	fld1					; st0 = 1, st1 = log_2(e) * x
	fld st1					; st0 = st2 = log_2(e) * x, st1 = 1
	fprem					; st0 = frac(log_2(e) * x), st1 = 1, st2 = log_2(e) * x
	f2xm1					; st0 = e^frac(x) - 1, st1 = 1, st2 = log_2(e) * x
	faddp st1, st0			; st0 = e^frac(x), st1 = log_2(e) * x
	fscale					; st0 = e^x, st1 = ...
	fstp st1				; st0 = e^x

	; sinh(x)
	
	fld1					; st0 = 2
	fld1					;
	faddp					;

	fldl2e					; st0 = e^-x, st1 = 2
	fmul dword [x]			;
	fchs					; (change sign)
	fld1					;
	fld st1					;
	fprem					;
	f2xm1					;
	faddp st1, st0			;
	fscale					;
	fstp st1				;

	fldl2e					; st0 = e^x, st1 = e^-x, st2 = 2
	fmul dword [x]			;
	fld1					;
	fld st1					;
	fprem					;
	f2xm1					;
	faddp st1, st0			;
	fscale					;
	fstp st1				;

	fsubrp					; st0 = e^x - e^-x, st1 = 2
	fdivrp					; st0 = sinh(x)

	; sinh^(-1)(x)

	fldln2					; st0 = ln(2)
	fld dword [x]			; st0 = x, st1 = ln(2)
	fld st0					; st0 = st1 = x, ...
	fmulp					; st0 = x^2
	fld1					; st0 = x^2, st1 = 1
	faddp					; st0 = x^2 + 1
	fsqrt					; st0 = sqrt(x^2 + 1)
	fld dword [x]			; st0 = x, st2 = sqrt(x^2 + 1)
	faddp					; st0 = x + sqrt(x^2 + 1)
	fyl2x					; st0 = sinh^(-1)(x)

	; exit

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
	mov esi, 0
	mov eax, 1
	mov ebx, 0
	int 80h
