INTERRUPTION EQU 16H

ASSUME CS:CODE, DS:DATA, SS:STACK

STACK SEGMENT STACK
	DW 1024 DUP(?)		
STACK ENDS

DATA	SEGMENT
	KEEP_CS DW 0 		
	KEEP_IP DW 0 		
DATA	ENDS

CODE	SEGMENT

SUBR_INT PROC FAR		
				
	JMP start
	
	INIT_SS DW 0000h
	INIT_SP DW 0000h
	INT_STACK DB 40 DUP(?)
	
	read_CMOS PROC
		PUSH DX
			;hours
		MOV AL, CH		;in CX=HHMM,
		CALL print_bcd
		CALL colon
			;minutes
		MOV AL, CL
		CALL print_bcd
		CALL colon
			;seconds
		MOV AL, DH		;in DH=SS
		CALL print_bcd
		POP DX
		RET	
	read_CMOS ENDP
	
	colon PROC
		MOV DL, ':'
		MOV AH, 02h
		INT 21H		
		RET
	colon ENDP
		
	print_bcd PROC
		PUSH DX		
		PUSH CX
		MOV CL, 4
		MOV AH, AL		
		AND AL, 00001111b	
		SHR AH, CL		
		ADD AL, '0'		
		ADD AH, '0'
		MOV DL, AH		
		MOV DH, AL
		MOV AH, 02h
		INT 21h
		MOV DL, DH		
		INT 21h
		POP CX			
		POP DX
		RET
	print_bcd ENDP
	
start:	
;Сохранение в память текущего состояния регистров
	
	MOV INIT_SP, SP
    	MOV INIT_SS, ss
    	mov sp, SEG INT_STACK	
    	mov ss, sp		
    	PUSH AX		
    	PUSH CX		
    	PUSH DX
    	
;процесс прерывания

	MOV AH, 02H		
	INT 1Ah		
	CALL read_CMOS
	POP DX			
	POP CX
	POP AX
	MOV ss, INIT_SS
    	MOV SP, INIT_SP
	MOV AL, 20H		 
	OUT 20H, AL 		
	IRET
			
SUBR_INT ENDP


Main	PROC FAR
	PUSH DS		
	SUB AX, AX		
	PUSH AX		
	MOV AX, DATA		
	MOV DS, AX

;текущее состояние вектора

	MOV AH, 35H 		
	MOV AL, 60H		
	INT 21H
	MOV KEEP_IP, BX	
	MOV KEEP_CS, ES 	

;новый вектор смещения

	PUSH DS
	MOV DX, OFFSET SUBR_INT	
	MOV AX, SEG SUBR_INT	
	MOV DS, AX		
	MOV AH, 25H					
	MOV AL, 60H		
	INT 21H		
	POP DS
	
;считывание символа с клавиатуры (в данном случае это q)
	readkey:
		MOV AH, 0		
		INT INTERRUPTION		
		CMP AH, 16		;код считывания символа q
		JNE readkey		
		INT 60H		

;восстановление исходного вектора прерывания
	CLI				
	PUSH DS			
	MOV DX, KEEP_IP		
	MOV AX, KEEP_CS		
	MOV DS, AX
	MOV AH, 25H			
	MOV AL, 60H			
	INT 21H			
	POP DS
	STI				
	MOV AH, 4CH
   	INT 21H
Main ENDP
CODE ENDS
END Main