; Стек  программы
AStack SEGMENT  STACK
    DW 12 DUP(?)
AStack  ENDS
;Данные программы
DATA      SEGMENT
;Директивы описания данных
a      DW    2
b      DW    1
i      DW    4
k      DW    -1
i1     DW    0
i2     DW    0

DATA      ENDS

; Код программы
CODE      SEGMENT
      ASSUME CS:CODE, DS:DATA, SS:AStack
	  
; Головная процедура
Main      PROC  FAR
      	push  DS
      	sub   AX,AX
      	push  AX
      	mov   AX,DATA
      	mov   DS,AX
      	mov cx, i
	shl cx, 1
	shl cx, 1
      	mov bx, b
	cmp a, bx
	;f5 = 20 - 4*i , при a>b, -(6*I - 6), при a<=b
	;f8 = - (6*i+8) , при a>b, 9 -3*(i-1), при a<=b
        jle f85ch
		mov ax, cx
        	neg cx
		add cx, 20
		mov i1, cx
		add ax, i
		add ax, i
		add ax, 8
		neg ax
		mov i2, ax

		jmp f85chf
	f85ch:
		mov ax, i
		mov i2, ax
		add i2, -1
		shl i2, 1
		add i2, ax
		add i2, 9

		add cx, i
		add cx, i
		add cx, -6
		neg cx
		mov i1, cx
	f85chf:

	;f6 = |i1 - i2|, при k<0 , max(7, |i2|), при k>=0
	mov bx, k
	  cmp bx, 0
	  jl f6ch
	    mov bx, i2
		cmp bx, 0
		jge temp1
		neg bx
		temp1:
			cmp bx, 7
			jl max1
				mov cx, bx
				jmp f6chf
			max1:
				mov cx, 7
			jmp f6chf
	f6ch:
		mov cx, i1
		sub cx, i2
      		cmp cx, 0
		jge temp2
		neg cx
		temp2:
	  f6chf:           
      ret
Main      ENDP
CODE      ENDS
END Main