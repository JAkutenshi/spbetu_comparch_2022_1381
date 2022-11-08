; a > b:
;	i_1 = -4i - 3
;	i_2 = i_1 +2*i - 7
;
;a <= b:
;	i_1 = 6i - 10
;	i_2 = i_1 / 2  + 11
;
DOSSEG
.MODEL SMALL
.STACK  100H
.DATA 
	a db -2
	b db  4
	i db -6
	k db  5
	i_2 db ? ; значение первой функции == i1
	i_4 db ? ; значение второй функции == i2
	res db 0
.CODE 
	mov ax, @data
	mov ds, ax
	mov al, a
	cmp al, b
	jle ElsePart
	; f2
	mov al, i ; i
	shl al, 1 ; 2*i
	shl al, 1 ; 4*i
	add al, 3 ; 4*i + 3
	neg al ;    -(4*i + 3) = -4*i - 3
	mov i_2, al; al = i_2
	; f4
	sub al, i ; -5*i - 3
	sub al, i ; -6*i - 3
	add al, 7 ; -6*i + 4
	mov i_4, al
	cmp k, 0
	jmp f7
	
	ElsePart:
	;f2
		mov al, i ; i
		mov bl, i ; i
		shl al, 1 ; 2*i
		shl al, 1 ; 4*i
		shl bl, 1 ; 2*i 
		add al, bl; 6*i
		sub al, 10; 6*i - 10
		mov i_2, al
	;f4	
		test al, 10000000b ; проверяем знаковый бит
		jnz negative ; если число отрицательное, то при сдвиге вправо нужно вернуть знаковый бит
		shr al, 1 ; 3*i - 5
		add al, 11 ; 3*i + 6 
		mov i_4, al
		jmp f7
		negative:
			shr al, 1 
			add al, 10000000b ; возвращаем знаковый бит отрицательному числу, потерянному при сдвиге
			add al, 11
			mov i_4, al
	f7:
		mov al, i_2
		mov bl, i_4
		
		getabs2: 
		neg al
		js getabs2 ; меняем у числа i_2 знак до тех пор, пока оно не станет положительным
		
		getabs4:
		neg bl
		js getabs4
		
		mov cl, k
		cmp cl, 0
		jge ElsePart_Final
		add res, al
		add res, bl
		jmp Ending
	
	ElsePart_Final:
		cmp al, 6
		jl min
		mov res, al
		jmp Ending
	min:
		mov res, 6
		jmp Ending
	Ending:
	mov al, i_2
	mov bl, i_4
	mov cl, res
	mov ah, 4ch
	int 21h
END