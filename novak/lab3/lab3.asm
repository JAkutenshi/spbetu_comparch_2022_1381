ASSUME CS:CODE, SS:AStack, DS:DATA
 
AStack    SEGMENT  STACK
          DW 32 DUP(0)
AStack    ENDS
 
DATA      SEGMENT
 
i	DW	0
a 	DW 	0
b	DW	0
k	DW	0
 
i1	DW	0		;f1
i2	DW	0		;f2
res	DW	0		;f3
 
DATA      ENDS
 
CODE SEGMENT
 
Main      PROC  FAR
	mov   AX,DATA
	mov   DS,AX
 
;Вычисление f1 и f2
	mov ax,a	;ax = a
	mov cx,i	;cx = i
	mov dx,b	;dx = b
	cmp ax,dx	;Сравнение значений a и b	
	jg PART1	;если a>b то на PART1
 
	;если a<=b:
	mov ax,8	;ax = 8
	mov dx,i	;dx = i
	sal dx,1	;dx = 2i
	sal cx,1	;cx = 2i
	sal cx,1	;cx = 4i
	add cx,dx	;cx = 2i + 4i = 6i
	sub ax,cx	;ax = 8 - 6i	
	mov i1,ax	;i1(f1) = ax = 8 - 6i
 
	mov cx,i	;cx = i
	mov dx, i	;dx = i
	sal dx,1	;dx = 2i
	add cx,dx	;cx = i + 2i = 3i
	mov ax, 10	;ax = 10
	sub ax, cx	;ax = ax - cx = 10 - 3i
	mov i2,ax	;i2(f2) = ax = 10 - 3i
	jmp PART2	;идем на PART2
 
PART1:			;если a>b
	mov cx,i	;cx = i	
	sal cx,1	;cx = 2i
	sal cx,1	;cx = 4i
	mov ax,7	;ax = 7
	sub ax,cx	;ax = ax - cx = 7 - 4i
	mov i1,ax	;i1(f1) = ax = 7 - 4i
 
	mov ax,-5	;ax = -5
	add ax,cx	;ax = ax + cx = 4i - 5
	neg ax		;ax = -(4i - 5)
	mov i2,ax	;i2(f2) = cx = -(4i - 5)
 
;Вычисление f3
PART2:
	mov bx,0
	cmp bx,i1	
	jg ABS1		;если 0 > i1, то на ABS1
	jmp CHECK	;иначе идем на CHECK
	
ABS1:
	neg i1

CHECK:
	cmp bx,i2
	jg PART21	;если 0 > i2, то на ABS2
	jmp PART21	;иначе идём на PART21

ABS2:
	neg i2

PART21:
	mov ax,k
 
	cmp ax,bx	;сравниваем k и 0
	jne PART4	;если k не равно 0, то на PART4
 	
			;если к = 0
	mov ax,i1	;ax = i1
	mov bx,6	;bx = 6
	cmp ax,bx
	jg PART3	;если i1 > 6 то на PART3
 
	mov res,ax	;res = ax = i1
	jmp ENDPART
PART3:
	mov res,bx	;res = bx = 6
	jmp ENDPART
 
PART4:			;если k не равно 0
	mov ax, i1
	add ax,i2	;ax = ax + i2
	mov res,ax	;res = ax = i1 + i2

ENDPART:
	int 20h
 
Main      ENDP
CODE      ENDS
          END Main
 