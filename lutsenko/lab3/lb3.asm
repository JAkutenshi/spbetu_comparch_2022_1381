AStack SEGMENT STACK
	DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
	a DW 4
	b DW 2
	i DW 2
	k DW 0
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
	mov ax, DATA
	mov ds, ax

	mov ax, a
	cmp ax,b
	mov cx, i ;i
	shl cx, 1 ;2i
	shl cx, 1 ;4i
	jle second ;( a<=b)

first: ;(a > b)
	mov ax, cx
	add ax, 3 ;(4i + 3)
	neg ax
	mov i1, ax
	mov ax, cx
	add ax, i ;5i
	add ax, i ;6i
	add ax, 8 ;(6i + 8)
	neg ax
	mov i2, ax
	jmp final

second:
	mov ax, cx; 4i
	sub ax, i ; 3i
	sub ax, 12 ;3i - 12
	neg ax ;-3i + 12
	mov i2, ax
	neg ax; 3i - 12
	shl ax, 1; 6i - 24
	add ax, 14 ; 6i - 10
	mov i1, ax
	
	jmp final

abs_1:
	neg i1
	mov ax, i1
	jmp ex
final:
	cmp k,0
	jne res_2 ;k != 0
res_1: ;k = 0
	mov ax, i2
	add i1, ax
	cmp i1, -1
	jle abs_1 ;if(i1 <= -1)
	jmp ex
res_2:
	mov cx, i2
	cmp i1, cx
	jl min_i1
min_i2:
	mov ax, i2
	jmp ex
min_i1:
	mov ax, i1
ex:
	mov res, ax
	ret

Main ENDP
CODE ENDS
END Main