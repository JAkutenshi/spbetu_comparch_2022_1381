DATA SEGMENT
        KEEP_CS DW 0
        KEEP_IP DW 0
		TMP1 DW 0
		TMP2 DW 0
		TMP3 DW 0
        HELLO   DB 'Sample text',10,13,'$'
		MESEND   DB 'End',10,13,'$'

DATA ENDS


AStack    SEGMENT  STACK
          DW 12 DUP(?)
AStack    ENDS



CODE      SEGMENT
          ASSUME CS:Code, DS:DATA, SS:AStack

SUBR_INT PROC FAR
        JMP start_proc
		
		save_SP DW 0000h
		save_SS DW 0000h
		INT_STACK DB 40 DUP(0)

start_proc:

    MOV save_SP, SP
	MOV save_SS, SS
	MOV SP, SEG INT_STACK
	MOV SS, SP
	MOV SP, offset start_proc
	PUSH AX
	PUSH DX
	PUSH BX
	PUSH CX
	MOV   DX, OFFSET HELLO
	MOV   AH,9
	mov bx, 3
	metka:
	int   21h
	cmp bx, 0
	sub bx, 1
	jne metka

	mov	ah,86h
	xor 	cx, cx
	mov	dx, 0000h
	int	15h
	
	MOV   	DX, OFFSET MESEND
	MOV 	AH,9
	int 	21h	

	POP  BX
	POP  DX
	POP  AX
	POP  CX
	MOV  SS, save_SS
	MOV  SP, save_SP
	MOV  AL, 20H
	
	OUT  20H,AL
       
	iret
	
SUBR_INT ENDP


Main	PROC  FAR
	push  DS
	sub   AX, AX
	push  AX
	mov   AX,DATA 
	mov   DS,AX   


	MOV  AH, 35H
	MOV  AL, 08H
	INT  21H
	MOV  KEEP_IP, BX
	MOV  KEEP_CS, ES
	
	
	PUSH DS
	MOV  DX, OFFSET SUBR_INT
	MOV  AX, SEG SUBR_INT
	MOV  DS, AX
	MOV  AH, 25H
	MOV  AL, 08H
	INT  21H
	POP  DS

	mov ah, 0h
	main_loop:
	int 16h
	cmp al, 27
	je exit
	jmp main_loop

	exit:
	

	CLI
	PUSH DS
	MOV  DX, KEEP_IP
	MOV  AX, KEEP_CS
	MOV  DS, AX
	MOV  AH, 25H
	MOV  AL, 08H
	INT  21H
	POP  DS
	STI
	
	MOV AH, 4Ch
	INT 21h
Main      ENDP
CODE ENDS
	END Main