ind EQU 10
AStack SEGMENT STACK
		DW 512 DUP(?)
AStack ENDS

DATA SEGMENT
	symbol DB 0
	msg DB 10,13,'Interruption has been completed$'
	KEEP_CS DW 0
	KEEP_IP DW 0
    
DATA ENDS

CODE SEGMENT
	ASSUME CS:CODE, DS:DATA, SS:AStack
	
interruption PROC FAR
print_loop:   
	    mov dl, symbol
	    mov ah, 02h
	    int 21h
	    loop print_loop
	    
	    mov ah, 09h
	    mov dx, offset msg
	    int 21h
	    mov al, 20h
	    out 20h, al
	    iret
interruption ENDP	
	
		
Main    PROC FAR
		push ds
		push ax
		mov ax, DATA
		mov ds, ax
		mov cx, ind
		mov ah, 01h
		int 21h
		mov symbol, al
		mov ah, 02h
		mov dl, 10
		int 21h
		
		mov ah, 35h
		mov al, 08h
		int 21h
		mov KEEP_IP, bx
		mov KEEP_CS, es
		push ds
		mov dx, OFFSET interruption
		mov ax, SEG interruption
		mov ds, ax
		mov ah, 25h
		mov al, 08h
		int 21h
		pop ds
		
		int 08h
		cli
		push ds
		mov dx, KEEP_IP
		mov ax, KEEP_CS
		mov ds, ax
		mov ah, 25h
		mov al, 08h
		int 21h
		pop ds
		sti
		ret
Main    ENDP
CODE    ENDS
	    END Main	
