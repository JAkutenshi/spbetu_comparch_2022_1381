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
.186
SUBR_INT PROC FAR		
				
	JMP start
	
	INIT_SS DW 0000h
	INIT_SP DW 0000h
	INT_STACK DB 40 DUP(?)
;считывание и печать даты из памяти cmos
	read_CMOS proc
	mov        al,0Bh               
        out        70h,al               
        in         al,71h               
        and        al,11111011b         
        out        71h,al               
        mov        al,32h               
        call       print_cmos           
        mov        al,9                 
        call       print_cmos
        mov        al,':'               
        int        29h                  
        mov        al,8                 
        call       print_cmos
        mov        al,':'              
        int        29h
        mov        al,7                 
        call       print_cmos
        ret
	read_CMOS endp

	print_cmos proc

	out        70h,al               
        in         al,71h               
        push       ax
        shr        al,4                 
        add        al,'0'               
        int        29h                  
        pop        ax
        and        al,0Fh               
        add        al,30h               
        int        29h                  
        ret
	print_cmos endp
	
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
;считывание символа с клавиатуры (в данном случае это e)
	readkey:
		MOV AH, 0		
		INT INTERRUPTION		
		CMP AH, 18		;код считывания символа e
		JNE readkey
		INT 09H
		
;текущее состояние вектора

	MOV AH, 35H 		
	MOV AL, INTERRUPTION		
	INT 21H
	MOV KEEP_IP, BX	
	MOV KEEP_CS, ES 	

;новый вектор смещения

	PUSH DS
	MOV DX, OFFSET SUBR_INT	
	MOV AX, SEG SUBR_INT	
	MOV DS, AX		
	MOV AH, 25H					
	MOV AL, INTERRUPTION		
	INT 21H		
	POP DS
	INT INTERRUPTION

;восстановление исходного вектора прерывания
	CLI				
	PUSH DS			
	MOV DX, KEEP_IP		
	MOV AX, KEEP_CS		
	MOV DS, AX
	MOV AH, 25H			
	MOV AL, INTERRUPTION			
	INT 21H			
	POP DS
	STI				
	MOV AH, 4CH
   	INT 21H
Main ENDP
CODE ENDS
END Main