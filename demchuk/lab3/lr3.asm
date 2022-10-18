AStack  SEGMENT  STACK
	DW 12 DUP(?)
AStack    ENDS

DATA    SEGMENT
	a DW -3
	b DW -2
	i DW -1
	k DW 0
	i1 DW ?
	i2 DW ?
	res DW ?
DATA      ENDS

CODE    SEGMENT

	ASSUME CS:CODE, DS:DATA, SS:AStack

Main    PROC  FAR
	push  ds
	sub   ax,ax
	push  ax
	mov   ax,DATA
	mov   ds,ax
f12:
	mov ax,i
	shl ax, 1	;ax=2i  
     	mov cx, a
     	cmp cx, b
     	jle f12_case2	;a<=b
f12_case1:
	;f1=15-2i
	mov i1,15
	sub i1,ax
	mov dx, i1
	
	;f2=2(i+1)-4=2i-2
	mov i2,ax
	sub i2,2
	mov dx, i2
	jmp result
f12_case2:
        ;f1=3i+4
	add ax,i	;ax=3i
	mov i1,ax
	add i1,4
	mov dx, i1
	
        ;f2=5-3(i+1)=2-3i
        mov i2,2
        sub i2,ax
        mov dx, i2
result:
	cmp i1,0
	jge f3_case1 	;i1>=0
	neg i1
f3_case1:
	cmp k,0
	jne abs_i2	;k!=0
	cmp i1,6
	jge min_6	;i1>=6
	mov ax,i1	;min=i1
	jmp f3_end
min_6:
	mov ax,6	;min=6
	jmp f3_end
abs_i2:
	cmp i2,0
	jge f3_case2 	;i2>=0
	neg i2
f3_case2:
	mov ax,i1
	add ax,i2
f3_end:
	mov res,ax
	ret
	
Main	ENDP
CODE    ENDS
END Main
