stack segment stack
    db 512 dup(?)
stack ends

data segment
	keep_cs dw 0
    keep_ip dw 0
data ends

code segment
    assume cs:code, ds:data, ss:stack


getTime proc
	push dx
	push cx
    xor cx, cx 
    mov bx, 10
    next:
        xor dx,dx
        div bx
        add dl, '0'
        push dx
        inc cx
    cmp ax, 0
    jnz next
    mov ah, 02h
    print:
        pop dx
        int 21h
    loop print
	pop cx
	pop dx
    ret
 
getTime endp


Subr_int proc far
    jmp start
	keep_sp DW 0000h
	keep_ss DW 0000h
    int_stack db 50 dup(0)

    start:
    mov keep_sp, sp
	mov keep_ss, ss
    mov sp, seg int_stack
	mov ss, sp
	mov sp, offset start
	push ax   
	push cx
	push dx

    mov ah, 00h
	int 1ah
	
	mov ax, cx
	call getTime
	mov ax, dx
	call getTime
	
	pop  dx
	pop  cx
	pop  ax 
    mov ss, keep_ss
	mov sp, keep_sp
	mov  al, 20h
	
	out 20h, al
	iret
Subr_int endp

Main proc far
    push ds      
	sub ax, ax  
	push ax  
	mov ax, data 
	mov ds, ax   
	 
    mov ah, 35h 
    mov al, 16h
    int 21h
    mov keep_ip, bx
    mov keep_cs, es

    check:
        mov ah, 0
		int 16h
		cmp ah, 39h
	jnz check

    push ds
    mov dx, offset Subr_int
    mov ax, seg Subr_int
    mov ds, ax
    mov ah, 25h
    mov al, 16h 
    int 21h 
    pop ds

    int 16h

    cli
    push ds
    mov dx, keep_ip
    mov ax, keep_cs
    mov ds, ax
    mov ah, 25h
    mov al, 16h
    int 21h
    pop ds
    sti

    mov ah, 4ch                          
	int 21h
Main endp
code ends
end Main
