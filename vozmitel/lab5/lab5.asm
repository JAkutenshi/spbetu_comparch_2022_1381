ASSUME CS:CODE, DS:DATA, SS:STACK

STACK    SEGMENT  STACK
          DW 1024 DUP(?)
STACK    ENDS

DATA SEGMENT
        KEEP_CS DW 0 ;буфер для хранения сегмента
        KEEP_IP DW 0 ;смещение вектора прерывания
DATA ENDS

CODE SEGMENT

OutPut PROC
	push dx
    push cx

    xor cx, cx ;cx - кол-во цифр
    mov bx, 10 ;основание сс

S1:
    xor dx, dx
    div bx ;делим число на основание сс и сохраняем остаток в стеке
    push dx
    inc cx ;увеличиваем счетчик

    test ax, ax ;сравнение с 0
    jnz S1

    mov ah, 2 ;вывод на дисплей

S2:
    pop dx
    add dl, '0'
    int 21h
    loop S2 ;Команда цикла(пока сх не 0)

    pop cx
    pop dx
    ret
OutPut endp


SUBR_INT PROC FAR

	JMP start

	save_sp DW 0000h
	save_ss DW 0000h
	INT_STACK DB 40 DUP(0)

start:
    mov save_sp, sp
	mov save_ss, ss
	mov sp, SEG INT_STACK
	mov ss, sp
	mov sp, offset start
	push ax
	push cx
	push dx ;сохранение изменяемых регистров

	mov ah, 00h ;читать часы(счетчик тиков)
	int 1AH
	
	mov ax, cx
	call OutPut ;вызов процедуры OutPut
	mov ax, dx
	call OutPut ;вызов процедуры OutPut
	
	pop dx
	pop cx
	pop ax ;возвращаем регистры в исходное состояние
	mov ss, save_ss
	mov sp, save_sp

	mov al, 20h
	OUT 20h, al
       
	iret ;возврат из прерывания
	
SUBR_INT ENDP


Main	PROC  FAR
	push DS ;запоминаем адрес psp
	sub AX,AX
	push AX
	mov AX,DATA ;получаем адрес DATA SEGMENT
	mov DS,AX ;записываем его в ds


;Запоминание текущего вектора прерывания
	MOV AH, 35H ;функция получения вектора
	MOV AL, 08H ;номер вектора
	INT 21H
	MOV KEEP_IP, BX ;запоминание смещения
	MOV KEEP_CS, ES ;и сегмента
	
;Установка вектора прерывания
	PUSH DS
	MOV DX, OFFSET SUBR_INT ;смещение для процедуры в DX
	MOV AX, SEG SUBR_INT ;сегмент процедуры
	MOV DS, AX ;помещаем в DS
	MOV AH, 25H ;функция установки вектора
	MOV AL, 08H ;номер вектора
	INT 21H ;меняем прерывание
	POP DS

	int 08H ;вызов прерывания

;Восстановление изначального вектора прерывания
	CLI
	PUSH DS
	MOV DX, KEEP_IP ;смещение для процедуры в DX
	MOV AX, KEEP_CS ;сегмент процедуры
	MOV DS, AX ;помещаем в DS
	MOV AH, 25H ;функция установки вектора
	MOV AL, 08H ;номер вектора
	INT 21H ;восстанавливаем вектор
	POP DS
	STI
	
	MOV AH, 4Ch                          
	INT 21h
Main      ENDP
CODE ENDS
	END Main 

