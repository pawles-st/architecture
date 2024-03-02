%include	'functions.asm'

section .text
global _start

_start:
	mov 	eax, 2			; current prime candidate
	jmp 	checkprime

nextprime:
	inc 	eax				; check next number
	cmp 	eax, 100000
	je  	exit

checkprime:
	mov 	ecx, 2			; current possible divisor of the candidate

primeloop:
	cmp		ecx, eax		; check divisor against number
	je  	output			; if equal, output the number
	mov 	edx, 0			; clear edx
	mov 	ebx, eax		; store current number in ebx
	idiv	ecx				; divide number by divisor
	mov 	eax, ebx		; restore current number to eax
	cmp 	edx, 0			; compare remainder to 0
	je  	nextprime		; if equal, number is not prime
	inc 	ecx				; otherwise, check next divisor
	jmp 	primeloop

output:
	call	iprintLF		; print prime
	jmp 	nextprime

exit:
	call	quit

