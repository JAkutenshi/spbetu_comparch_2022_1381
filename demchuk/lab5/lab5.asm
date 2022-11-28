ASSUME CS:CODE, DS:DATA SS:AStack

AStack	SEGMENT  STACK
	DW 512 DUP(?)
AStack	ENDS

DATA	SEGMENT
	keep_cs dw 0
	keep_ip dw 0
	save_ss dw 0
	save_sp dw 0
	save_ax dw 0
DATA	ENDS

CODE	SEGMENT
.186
SUBR_INT  PROC  FAR
	  
        start:
        ;сохранение регистров
        mov save_ss, ss
        mov save_sp, sp
        mov save_ax, ax
        mov sp, offset start
        mov ax, seg STACK
        mov ss, ax
        mov ax, save_ax
          
        push ax
        push ds
        mov ax, seg SUBR_INT
        mov ds, ax
        mov ax, save_ax
          
        ;обработка прерывания
        mov ah, 29h
        mov al, 0Bh
        out 70h, al
        in al, 71h
        and al, 11111011b
        out 71h, al
        mov al, 4
        call PRINT
        mov al, 'h'
        int 29h
        mov al, ' '
        int 29h
        mov al, 2
        call PRINT
        mov al, 'm'
        int 29h
        mov al, ' '
        int 29h
        mov al, 0
        call PRINT
        mov al, 's'
        int 29h
        mov al, ' '
        int 29h
          
        ;восстановление регистров
        pop ds
        pop ax
        mov sp, save_sp
        mov ax, save_ss
        mov ss, ax
        mov ax, save_ax
        mov al, 20h
        out 20h, al
        iret
          
SUBR_INT  ENDP

PRINT  PROC  NEAR

	out 70h, al
	in al, 71h
	push ax
	shr al, 4
	add al, '0'
	int 29h
	pop ax
	and al, 0Fh
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
	mov ah, 35h
	mov al, 08h
	int 21h
	mov keep_ip, bx
	mov keep_cs, es
	
	;установка нового вектора прерывания
	push ds
	mov dx, offset SUBR_INT
	mov ax, seg SUBR_INT
	mov ds, ax
	mov ah, 25h
	mov al, 08h
	int 21h
	pop ds
	
	int 08h
	
	;восстановление изначального вектора прерывания
	cli	;if=0
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
