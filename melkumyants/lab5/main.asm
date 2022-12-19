AStack  SEGMENT STACK
    DB 512 DUP(?)
AStack  ENDS

DATA    SEGMENT
    KEEP_CS DW 0    
    KEEP_IP DW 0
	MESSAGE DB 'HELLO!', 0dh, 0ah, '$'
	FINALLY DB 'END!', 0dh, 0ah, '$'
DATA    ENDS

CODE    SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

WriteMsg  PROC  NEAR
          mov AH, 9
          int 21h 
          ret
WriteMsg  ENDP

FUNC PROC FAR
		push ax
		push cx
		push dx
		
		mov dx, OFFSET MESSAGE
		mov cx, 5
		lp:
			call WriteMsg
			loop lp

		mov cx, 0033h 
		mov dx, 00FFh
		mov ah, 86h
		int 15h

		mov dx, OFFSET FINALLY
		call WriteMsg 
		
		pop dx
	   	pop cx
	   	pop ax
	   	mov al, 20h
	   	out 20h, al
		iret
FUNC ENDP

MAIN PROC FAR
    push ds
	sub ax, ax
	push ax
    mov ax, DATA
    mov ds, ax
    
    mov ah, 35h 
    mov al, 23h 
    int 21h
    mov KEEP_IP, bx 
    mov KEEP_CS, es 
    
    push ds
    mov dx, OFFSET FUNC 
    mov ax, SEG FUNC 
    mov ds, ax 
    mov ah, 25h 
    mov al, 23h 
    int 21h
    pop ds
    
    begin:
    	mov ah, 0
		int 16h
		cmp al, 3
		jnz begin
		int 23h

    	cli
    	push ds
    	mov dx, KEEP_IP
    	mov ax, KEEP_CS
    	mov ds, ax
    	mov ah, 25h
    	mov al, 23h
    	int 21h
    	pop ds
    	sti
   		mov ah, 4ch
		int 21h    
MAIN ENDP
CODE ENDS
     END MAIN

