AStack SEGMENT STACK
	DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
	a DW 1
	b DW 3
	i DW -2
	k DW -1
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
	
	jmp enter_function
	
enter_function:
	mov AX, i
	
	shl AX, 1	;\
				;	> 4i
	shl AX, 1	;|
	
	mov CX, a ; CX = a
	cmp b, CX
	
	jge function1_p2 ; a <= b
	
	; a > b
	mov CX, AX ; CX = 4i
	
	add AX, 3 ; AX = 4i + 3
	neg AX ; -(4i + 3) f1 end
	
	; f2 a > b
	sub CX, 5 ; 4i - 5
	neg CX ; -(4i - 5) f2 end
	
	jmp function12_end
	
function1_p2:
	mov CX, i ; CX = i
	shl CX, 1 ; CX = 2i
	add AX, CX ; 4i + 2i
	sub AX, 10 ; 6i - 10 f1 end
	
	; f2 a <= b
	neg CX ; CX = -2i
	sub CX, i ; CX = -3i
	add CX, 10 ; 10 - 3i f2 end

	jmp function12_end
	
function12_end:
	mov i1, AX
	mov i2, CX
	
function3:
	mov CX, k
	cmp CX, 0
	jge f3_k_ge0
	jmp f3_k_l0
	
f3_k_l0: ; k < 0	
	mov AX, i1
	sub AX, i2 ; AX = i1-i2
	
	cmp AX, 0
	jge	min	; \ abs
	neg AX ; | abs
	jmp min

min: 
	cmp AX, 2 ; |i1-i2| <= 2
	jle function3_end
	mov AX, 2
	jmp function3_end

f3_k_ge0: ; k >= 0
	mov AX, i2
	neg AX ; AX = -i2
	cmp AX, -6
	jge function3_end
	mov AX, -6
	jmp function3_end
	
function3_end:
	mov result, AX
	ret
	
Main ENDP
CODE ENDS

END Main