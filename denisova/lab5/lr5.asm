AStack SEGMENT STACK
 DW 512 DUP(?)
AStack ENDS

DATA SEGMENT
	keep_cs dw 0
	keep_ip dw 0
Str_1  LABEL  BYTE
	DB '*******************',13,10,'$'
DATA ENDS

CODE SEGMENT
 ASSUME CS:CODE, DS:DATA, SS:AStack

Main PROC FAR
 	push DS
 	sub AX,AX
 	push AX
 	mov AX,DATA
 	mov DS,AX

	mov ah, 35h
	mov al, 60h
	int 21h
	mov keep_ip, bx
	mov keep_cs, es

	PUSH ds
 	mov dx, OFFSET SUBR_INT ; смещение для процедуры в DX
 	mov ax, SEG SUBR_INT ; сегмент процедуры
 	mov ds, AX ; помещаем в DS
 	mov ah, 25h ; функция установки вектора
 	mov al, 60h ; номер вектора
 	int 21h ; меняем прерывание
 	pop ds

 	mov  ax, SEG DATA               ; Загрузка в DS адреса начала
 	mov  ds, ax                     ; сегмента данных
 	mov  dx, OFFSET Str_1           ; Загрузка в dx смещения текста
Display:
   	mov  ah, 9                      ; # функции ДОС печати строки
   	int  21h 

	mov ah, 100
	int 60h

	mov  ah, 9                      ; # функции ДОС печати строки
   	int  21h 

	
	CLI
 	push ds
 	mov dx, KEEP_IP
 	mov ax, KEEP_CS
 	mov ds, ax
 	mov ah, 25h
 	mov al, 60h
 	int 21h ; восстанавливаем старый вектор прерывания
 	pop ds
 	STI

	mov ah, 4ch
	int 21h
          
Main ENDP

SUBR_INT PROC FAR
	push ax
	push cx
	mov cl, ah
l_2:
	mov ax, 0
l_1:	
	dec ax
	jne l_1
	dec cl
	jne l_2

	mov al, 20h
	out 20h, al
	pop cx
	pop ax
	iret
SUBR_INT ENDP

CODE ENDS
 END Main