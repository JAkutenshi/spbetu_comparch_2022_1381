ASSUME CS:CODE, DS:DATA, SS:STACK

STACK    SEGMENT  STACK
          DW 1024 DUP(?)
STACK    ENDS

DATA SEGMENT
        KEEP_CS DW 0 ;буфер для хранения сегмента
        KEEP_IP DW 0 ;смещение вектора прерывания
		CNT DB 0;
DATA ENDS

CODE SEGMENT

OutPut PROC
	push ax
    push cx
    push dx
    push bx
    xor cx,cx        ;Обнуление CX
    mov bx,10        ;В BX делитель (10 для десятичной системы)

S1:        ;Цикл получения остатков от деления
    xor dx,dx        ;Обнуление старшей части двойного слова
    div bx        ;Деление AX=(DX:AX)/BX, остаток в DX
    add dl,'0'        ;Преобразование остатка в код символа
    push dx        ;Сохранение в стеке
    inc cx        ;Увеличение счетчика символов
    test ax,ax        ;Проверка AX
    jnz S1      ;Переход к началу цикла, если частное не 0.

	mov ah, 02h ;вывод на дисплей

S2:        ;Цикл извлечения символов из стека
    pop dx        ;Восстановление символа из стека
	int 21h
    mov [di],dl       ;Сохранение символа в буфере
    inc di        ;Инкремент адреса буфера
    loop S2      ;Команда цикла
    pop bx
    pop dx
    pop cx
    pop ax
    ret
OutPut endp

SYMBOL PROC
    mov ah,02h
    mov dl,':'
    int 21h
    ret
SYMBOL ENDP

NUM PROC  
    push dx
        aam 
        add ax,3030h 
        mov dl,ah 
        mov dh,al 
        mov ah,02h
        int 21h 
        mov dl,dh 
        int 21h
    pop dx
    ret
NUM ENDP


SUBR_INT PROC FAR
	push ax
	push cx
	push dx ;сохранение изменяемых регистров
	
	sub bx, 1
	cmp bx, 0
    JNE final

	mov ah, 00h ;читать часы(счетчик тиков)
	int 1AH
	
	mov ax, cx
	call OutPut ;вызов процедуры OutPut
	mov ax, dx
	call OutPut ;вызов процедуры OutPut
	
	mov ah, 02h
	mov dl,' ' ; разделение
    int 21h	

	mov ah, 2ch ;получение времени
	int 21h
	
	mov al, ch ;часы
	call NUM
	call SYMBOl

	mov al, cl ;мин
	call NUM
	call SYMBOl

	mov al, dh ;сек
	call NUM

final:
	pop dx
	pop cx
	pop ax ;возвращаем регистры в исходное состояние

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
	

	mov bx, 20
;Установка вектора прерывания
	PUSH DS
	MOV DX, OFFSET SUBR_INT ;смещение для процедуры в DX
	MOV AX, SEG SUBR_INT ;сегмент процедуры
	MOV DS, AX ;помещаем в DS
	MOV AH, 25H ;функция установки вектора
	MOV AL, 08H ;номер вектора
	INT 21H ;меняем прерывание
	POP DS


	
main_loop:
    cmp bx, 0
    JNE main_loop

	;int 08H ;вызов прерывания

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
