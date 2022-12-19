DATA SEGMENT
        KEEP_CS DW 0 ;буфер для хранения сегмента
        KEEP_IP DW 0 ;смещение вектора прерывания
        message DB 'ESC = exit, + = increase by 100, - = reduce by 100', 0dh, 0ah, '$'
DATA ENDS

STACK    SEGMENT  STACK
          DW 1024 DUP(?)
STACK    ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:STACK

SUBR_INT PROC FAR
	push ax ; сохранение изменяемых регистров
	push bx ;
	push dx ;
	push cx ;
	
	;mov di, 6000 ;частота звука
	mov bx, 10 ;длительность (время)
	
	start:    ;включение динамика
	mov al, 10110110b ;управляющее слово таймера:канал 2
	out 43h, al ;выводим значение в порт таймера
	mov dx,0014H
    	mov ax, 1000 ;высота звука
    	div di ;деление al = ax/di  ah=остаток

	out 42h, al ;выводим младший байт счетчика во 2-й канал таймера
	mov al, ah
	out 42h, al ;выводим старший байт
	
	in al, 61h ;текущее состояние порта 61h в AL
	mov ah, al
	or al, 3 ; устанавливаем биты 0 и 1 (включить спикер и использовать 2-й канал для генерации импульсов спикера)
	out 61h, al ; выводим значение в управляющий регистр

	l1:	mov cx, 2801h
	l2:	loop l2 ;цикл во время работы динамика
	dec bx ;минус 1
	jnz l1   ;пока не равно нулю
	
	finish:   ;выключение динамика
	mov al, ah ; получаем значение из управляющего регистра порта в PPI (текущее состояние порта 61h)
	and al, 11111100b	; сбрасываем биты 0 и 1 
	out 61h,al	; выводим значение в управляющий регистр порта B PPI (контроллера 8255)

	pop ax ; восстановление регистров
	pop bx ;
	pop cx ;
	pop dx ;
	mov al, 20h
	out 20h, al
	iret
SUBR_INT ENDP
	
Main PROC FAR
	push ds
	sub ax,ax
	push ax
	mov ax, DATA
	mov ds, ax
	mov di, 5000 ;частота звука
    
;Запоминание текущего вектора прерывания
	mov ah, 35h ;функция получения вектора
	mov al, 08h ;номер вектора
	int 21H
	mov KEEP_IP, bx ;запоминание смещения
	mov KEEP_CS, es ;и сегмента
	
;Установка вектора прерывания
	push ds
	mov dx, OFFSET SUBR_INT ;смещение для процедуры в DX
	mov ax, SEG SUBR_INT ;сегмент процедуры
	mov ds, ax ;помещаем в DS
	mov ah, 25h ;функция установки вектора
	mov al, 08h ;номер вектора
	int 21h ;меняем прерывание
	pop ds
	;int 08h ;вызов прерывания

	jmp read

text:
mov dx, offset message
mov ah, 09h
int 21h
jmp read

;Считывание символа
read:
push ax
mov ah, 1h ;Определение, есть ли символ в буфере клавиатуры
int 21H

cmp al, '-'
je minus

cmp al, '+'
je plus

cmp al, 1bh ;проверка на ESC
pop ax
jnz text ;пока не равно нулю
jmp final_esc

minus:
sub di, 100
pop ax
jmp read

plus:
add di, 100
pop ax
jmp read

;Восстановление изначального вектора прерывания
final_esc:
	CLI
	push ds
	mov dx, KEEP_IP ;смещение для процедуры в DX
	mov ax, KEEP_CS ;сегмент процедуры
	mov ds, ax ;помещаем в DS
	mov ah, 25h ;функция установки вектора
	mov al, 08h ;номер вектора
	int 21h ;восстанавливаем старый вектор
	pop ds
	STI
	RET
	
Main      ENDP

CODE ENDS
	END Main 
	
