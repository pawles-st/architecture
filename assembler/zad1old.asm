%include	'functions.asm'

section .data

newline		db		'', 0h

section .text
global _start

_start:
	mov		eax, 123 			; input value
	mov		ebx, 16				; 16 constant

divide:
	mov		edx, 0				; clear edx
	idiv	ebx					; divide eax by ebx (= 16)

;	push	eax					; push eax on stack
;	mov		eax, edx			; move edx to eax

	cmp		edx, 10				; check if eax >= 10
	jge		tohex				; if so, convert to letter
	jl		todig				; otherwise, convert to digit

tohex:
	add		edx, 39
	call	iprint
	;add		edx, 87			; convert value to ascii code
	;jmp		storedig
	;push	eax
	;call	iprint
	jmp		checkdone
;	jmp		digprint

todig:
	call	iprint
	;add		edx, 48				; convert value to ascii code
	;push	eax
	;call	sprint
	jmp		checkdone
;	jmp		digprint

storedig:
	push eax
	jmp

digprint:
	
	
checkdone:
	;pop		eax					; restore result from stack
	cmp		eax, 0				; check if result = 0
	jnz		divide				; if not, divide
	call	quit				; else, finish
	
