 AStack SEGMENT STACK
	DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
	a DW 2
	b DW 4
	i DW 5
	k DW 3
	i1 DW ?
	i2 DW ?
	result DW ?
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:AStack
	
Main PROC FAR
	push DS
	sub AX, AX
	push AX
	mov AX, DATA
	mov DS, AX
	
start_calc:
	mov AX, i ; AX = i
	shl AX, 1 ; AX = 2i
	mov CX, b ; CX = b

	cmp a, CX 

	jg calc_1 ; jump if a > b

calc_2: ; a <= b
	add AX, i ; AX = 3i
	mov CX, AX ; CX = 3i
	add AX, 4 ; AX = 3i + 4
	mov i1, AX ; i1 = 3i + 4
	
	neg CX	; CX = -3i
	add CX, 10 ; CX = 10 - 3i
	mov i2, CX ; i2 = 10 - 3i
	
	jmp res_calc

calc_1: ; a > b
	mov CX, 15 ; CX = 15
	sub CX, AX ; CX = 15 - 2i
	mov i1, CX ; i1 = 15 - 2i

	shl AX, 1 ; AX = 4i
	sub AX, 5 ; AX = 4i - 5
	neg AX ; AX = - (4i - 5)
	mov i2, AX ; i2 = - (4i - 5)

res_calc:
	mov AX, k ; AX = k
	cmp AX, 0 

	jl res_1 ; jump if k < 0

	; k >= 0
	mov AX, i2 ; AX = i2
	cmp AX, 0 
	jge mod_ok ; AX = abs(i2)
	
	neg AX

mod_ok: 
	cmp AX, 7
	jge ok_1 ; jump if abs(i2) >= 7
	
	mov AX, 7
ok_1:
	mov result, AX ; result = AX
	jmp finish
res_1:
	mov AX, i1 ; AX = i1
	sub AX, i2 ; AX = i1 - i2
	cmp AX, 0
	jge mod_ok_1 ; AX = abs(i1 - i2)

	neg AX
mod_ok_1:
	mov result, AX

finish:
	ret

MAIN ENDP
CODE ENDS

END Main