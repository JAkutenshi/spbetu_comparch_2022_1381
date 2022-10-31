AStack SEGMENT STACK
	DW 12 DUP(?)
AStack ENDS
DATA SEGMENT
	a DW -3
	b DW -2
	i DW 22
	k DW -2
	i1 DW ?
	i2 DW ?
	res DW ?
DATA ENDS
CODE SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:AStack
Main PROC FAR
	push ds
	sub ax,ax
	push ax
	mov ax,DATA
	mov ds,ax
f12:
	mov ax,i
	shl ax,1  
	add ax,i;a=3*i
    mov cx,a
    cmp cx,b
    jle f12step2;a<=b
f12step1:
	;f1=2*(2-3*i)
	mov i1,2
	sub i1,ax
	shl i1,1
	mov dx,i1
	;f2=2*i-2
	sub ax,i
	mov i2,ax
	sub i2,2
	mov dx,i2
	jmp f3
f12step2:
    ;f1=3*i+6
	mov i1,ax
	add i1,6
	mov dx,i1
    ;f2=2-3*i
    mov i2,2
    sub i2,ax
    mov dx,i2
f3:
	cmp i1,0
	jge f3step1 ;i1>=0
	neg i1
f3step1:
	cmp i2,0
	jge f3step2 ;i2>=0
	neg i2
f3step2:
	cmp k,0
	jge f3step3 ; k>=0
	mov ax,i1
	sub ax,i2
	jmp f3end
f3step3:
	sub i2,3
	cmp i2,4
	jge max4 ;i2>=4
	mov ax,4	
	jmp f3end
max4:
	mov ax,i2
f3end:
	mov res,ax
	ret
Main	ENDP
CODE    ENDS
END Main