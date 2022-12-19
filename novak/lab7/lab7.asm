AStack SEGMENT STACK
 DB 1024 DUP(?)
AStack ENDS

DATA SEGMENT
 A dd 567d ;число вводимое
Result dd 0 ; результат деления
Remainder dw 0 ;остаток
Next1 db '\n','$'
res_str db 12 dup (0)
 
 hr dw 0
 lr dw 0
DATA ENDS

CODE SEGMENT
 ASSUME CS:CODE, DS:data, SS:AStack

start PROC NEAR
mov ax, data
mov ds,ax
 call numb_to_string ; То что в Result переводит в строку res_str
 push cx
 push si
 call print
 
 call FAR PTR str_to_num
 pop si
 pop cx
 
 mov si, offset res_str
 call numb_to_string ; То что в Result переводит в строку res_str
 mov si, offset res_str
 call print2
 
 mov ax, 4c00h ; выход в DOS
int 21h
start endp 

numb_to_string proc NEAR
 lea si, res_str	;загружаем в si смещение строки
mov cx,0 
mov bx,10			; делитель

mov ax, word ptr [A+2]			;поместили в ax 2 байта от смещения нашего числа
 mov word ptr [Result+2], ax	;поместили по адресу Result+2 в 2 байта ax
mov ax, word ptr [A]			;поместили в ax 2 байта со смещения числа
 mov word ptr [Result], ax		;поместили по адресу Result в 2 байта ax
 again:

	xor dx,dx						;делим старшее слово
	mov ax, word ptr [Result+2]		;поместили в ax 2 байта от Result+2
	div bx							;al=ax/10
	mov word ptr [Result+2], ax		;сохраняем результат от деления старшего слова
								;в dx остаток от деления							
	mov ax,word ptr [Result]		;делим младшее слово
	div bx							;al=ax/10
	mov word ptr [Result], ax		;сохраняем результат от деления младшего слова
	mov word ptr [Remainder], dx	;сохраняем остаток от деления
	
	and dx, 0FFh					;переводим цифру в символ и сохраняем 
	add dx, '0'						;добавляем код 0 из аски
	mov [si],dl						;сохраняем в si
	inc si							;смещение следующего символа в строке
	inc cx							;счетчик символов

	mov ax, word ptr [Result]		;если частное от деления не равно 0, то повторяем операцию
	cmp ax,0
	jnz again

	mov ax, word ptr [Result+2]
	cmp ax,0
	jnz again
 ret 

;печать строки в обратном порядке
;в cx - длина строки
numb_to_string ENDP

str_to_num PROC FAR
lea si, res_str		;загружаем в si смещение до строки
mov bx,10
xor dx,dx
again_r:
	xor ah,ah
	mov al, [si]
	cmp al,0
	jz exit
	sub ax, '0' ; ax - цифра
	
	push di
	push bp
	mov di, ax	
	mov bp, dx	
	mov ax,hr
	mov dx,0
	mul bx
	mov hr,ax
	;sub dx,dx
	mov ax, di	
	mov dx, bp	
	pop bp

	mov di, ax	
	mov ax,lr
	mov dx,0
	mul bx
	mov lr,ax
	;sub ax, ax
	mov ax, di	
	pop di

	add ax, lr
	mov lr,ax

	mov ax,hr
	add ax,dx
	mov hr,ax
	inc si
	jmp again_r

 exit:
	mov ax, hr
	mov dx, lr
	mov word ptr [A+2], ax
	mov word ptr [A], dx
 ret
 
; печать строки в обратном порядке
; в cx - длина строки
str_to_num endp

print proc NEAR
print_s:
	mov dl,[si-1]
	mov ah,02h
	int 21h
	dec si
	loop print_s
	mov dl, offset Next1
	mov ah,02h
	int 21h
 ret

print endp

print2 proc NEAR
print_s2:
	mov dl,[si]
	mov ah,02h
	int 21h
	inc si
	loop print_s2
 ret
print2 endp
CODE ENDS
 END start