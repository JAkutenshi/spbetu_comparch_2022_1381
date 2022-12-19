AStack  SEGMENT STACK
    DB 512 DUP(?)
AStack  ENDS

DATA    SEGMENT
    prev_cs DW 0    
    prev_ip DW 0
	MESSAGE DB 'Message', 0dh, 0ah, '$'
    MESSAGE_DELAY DB 'Delay...', 0dh, 0ah, '$'
DATA    ENDS

CODE    SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

new_line PROC NEAR  

   PUSH AX  
  
   MOV AH, 0EH     
   MOV AL, 0AH     
   INT 10H        

   MOV AH, 0EH   
   MOV AL, 0DH       
   INT 10H        

   POP AX   
   RET

new_line ENDP 

writetime PROC  
    push dx
    aam 
    add ax, 3030h 
    mov dl,ah 
    mov dh,al 
    mov ah,02 
    int 21h 
    mov dl,dh 
    int 21h
    pop dx
    mov ah,2
    mov dl,':'
    int 21h
    
    ret
writetime ENDP



time PROC
    push ax
    push bx
    push cx
    push dx
    
    mov ah, 02h 
	int 21h		
	mov al, ch 
	call writetime
	mov al, cl 
	call writetime
	mov al, dh 
	call writetime
    call new_line

    pop dx
    pop cx
    pop bx
    pop ax
    ret
time ENDP

delay  PROC  NEAR
          push ax
          push bx
          push cx
          push dx

          mov cx,0fh; задаём начало временного промежутка в микросекундах
          mov dx,4240h; окончание временного промежутка
          mov ah,86h; установка вектора
          int 15h; вызов прерывания
         
          
          pop dx
          pop cx
          pop bx
          pop ax
          ret
delay ENDP

Write  PROC  NEAR
          push ax
          push bx
          push cx
          push dx

          mov ah, 9h ;функция установки вектора
          int 21h  ;вывод строки на экран

          pop dx
          pop cx
          pop bx
          pop ax

          ret
Write  ENDP

FUNC PROC FAR
		push ax
        push bx
		push cx
		push dx


        mov dx, OFFSET MESSAGE
        mov cx, 4
        mov ax, 1
        lp1:
           mov dx, OFFSET MESSAGE
           mov bx, cx               
           call Write
           cmp cx, 1
           je lp3
           mov cx, ax
           
           lp2:
               call time
               call delay
           loop lp2  

        shl ax, 1
        mov cx,bx
        loop lp1    
	
		lp3:
		pop dx
	   	pop cx
        pop bx
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
    
    mov ah,25h ;функция установки вектора
    mov al,60h ;номер вектора 
    int 21h
    mov prev_ip, bx 
    mov prev_cs, es 
    
    push ds
    mov dx, OFFSET FUNC 
    mov ax, SEG FUNC 
    mov ds, ax 
    mov ah, 25h 
    mov al, 60h 
    int 21h
    pop ds
	int 60h
    CLI
    push ds
    mov dx, prev_ip
    mov ax, prev_cs
    mov ds, ax
    mov ah, 25h
    mov al, 60h
    int 21h
    pop ds
    STI
     ret
 
MAIN ENDP
CODE ENDS
     END MAIN