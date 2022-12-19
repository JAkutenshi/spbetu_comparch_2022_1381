AStack SEGMENT STACK
	DW 12 DUP(?)
AStack ENDS
DATA SEGMENT
	a DW 2
	b DW 5
	i DW 5
	k DW 1
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
	add ax,i
	shl ax,1;a=4*i
    mov cx,a
    cmp cx,b
    jle f12step2;a<=b
f12step1:
	;f1=-(4*i+3)
	mov i1,ax
	add i1,3
	neg i1
	mov dx,i1
	;f2=20-4*i		
	mov i2,20
	sub i2,ax
	mov dx,i2
	jmp f3
f12step2:
    ;f1=6*i-10
	sub ax,i
	shl ax,1
	mov i1,ax
	sub i1,10
	mov dx,i1
    ;f2=-(6*i-4)
	mov i2,ax
	sub i2,6
	neg i2
	mov dx,i2
f3:
	mov bx,i1
	sub bx,i2
	cmp bx,0
	jge f3step1 ;i1>=0
	neg bx
f3step1:
	cmp i2,0
	jge f3step2 ;i2>=0
	neg i2
f3step2:
	cmp k,0
	jge f3step3 ; k>=0
	mov ax,bx
	jmp f3end
f3step3:
	cmp i2,7
	jge max4 
	mov ax,7	
	jmp f3end
max4:
	mov ax,i2
f3end:
	mov res,ax
	ret
Main	ENDP
CODE    ENDS
END Main