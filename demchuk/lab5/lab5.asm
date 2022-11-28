ASSUME CS:CODE, DS:DATA, SS:AStack

AStack	SEGMENT  STACK
	DW 512 DUP(?)
AStack	ENDS

DATA	SEGMENT
	keep_cs dw 0
	keep_ip dw 0
DATA	ENDS

CODE	SEGMENT
.186
SUBR_INT  PROC  FAR
	  
        start: 
        push ax
          
        ;обработка прерывания
        mov ah, 29h	;функция печати символа
        mov al, 0Bh
        out 70h, al	;выбор адреса CMOS
        in al, 71h	;ввод байта из CMOS в регистр
        and al, 11111011b	;обнуление бита 
        out 71h, al
        mov al, 4	;текущий час
        call PRINT
        mov al, ':'
        int 29h
        mov al, 2	;текущая минута
        call PRINT
        mov al, ':'
        int 29h
        mov al, 0	;текущая секунда
        call PRINT
          
        pop ax
        mov al, 20h
        out 20h, al
        iret
          
SUBR_INT  ENDP

PRINT  PROC  NEAR

	out 70h, al
	in al, 71h
	push ax
	shr al, 4	;старшие 4 бита
	add al, '0'
	int 29h
	pop ax
	and al, 0Fh	;младшие 4 бита
	add al, 30h
	int 29h
	ret
	
PRINT  ENDP

; Головная процедура
Main	PROC  FAR

	push ds
	sub ax, ax
	push ax
	mov ax, DATA
	mov ds, ax
	
	;текущий вектор прерывания
	mov ah, 35h	;функция получения вектора
	mov al, 08h
	int 21h
	mov keep_ip, bx
	mov keep_cs, es
	
	;установка нового вектора прерывания
	push ds
	mov dx, offset SUBR_INT
	mov ax, seg SUBR_INT
	mov ds, ax
	mov ah, 25h	;функция установки вектора
	mov al, 08h
	int 21h
	pop ds
	
	int 08h
	
	;восстановление изначального вектора прерывания
	cli	;if=0 флаг разрешения прерываний
	push ds
	mov dx, keep_ip
	mov ax, keep_cs
	mov ds, ax
	mov ah, 25h
	mov al, 08h
	int 21h
	pop ds
	sti	;if=1
	
	mov ah, 4ch
	int 21h
		
Main	ENDP
CODE	ENDS
	END Main
