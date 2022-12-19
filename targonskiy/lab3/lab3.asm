 AStack SEGMENT STACK
	DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
	a DW 1
	b DW 2
	i DW 3
	k DW 4
	; i1 DW ?
	; i2 DW ?
	res DW ?
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
	shl AX, 1 ; AX = 6i
    neg AX ; AX = -6i
	add AX, 6 ; AX = -6i+6
	; mov i1, AX ; i1 = -6i+6
	
	neg CX	; CX = -3i
	add CX, 2 ; CX = 2 - 3i
	; mov i2, CX ; i2 = 2 - 3i
	
	jmp res_calc

calc_1: ; a > b
    mov CX, AX ; CX = 2i
	sub CX, 2 ; CX = 2i - 2
	; mov i2, CX ; i2 = 2i - 2

    shl AX, 1 ; AX = 4i
    neg AX ; AX = -4i
    add AX, 20 ; AX = -4i + 20
	; mov i1, AX ; i1 = -4i + 20

res_calc:
min:
	neg CX
	cmp k, 0
	jge max		;if(k>=0)
	add CX, AX	;-i2+i1
	abs:
	neg CX 
	js abs      ;|-i2+i1|
	cmp CX, 2
	jge	result_min ;if(|i2 - i1|>=2)
	jmp result
	
max:
	cmp CX, -6
	jle result_max ;if(-i2<=-6)
	jmp result

result_min:
	mov CX, 2
	jmp result

result_max: mov CX, -6
result: 
	mov res, CX

MAIN ENDP
CODE ENDS

END Main