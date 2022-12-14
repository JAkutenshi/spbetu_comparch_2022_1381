AStack  SEGMENT STACK
    DB 1024 DUP(?)
AStack  ENDS

DATA    SEGMENT
	n DW 0
    eight_str DB 10, 13, ' ', '$'
	NUMBER DW -8
DATA    ENDS

CODE    SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack
    

WriteMsg  PROC  NEAR
          mov AH, 9
          int 21h 
          ret
WriteMsg  ENDP



convert_to_eight_str proc FAR
    push ax
    push cx
    push dx
    push bx
    xor cx,cx         
    mov bx,8             
    mov di, offset eight_str
 
loop1:                 
    xor dx,dx              
    div bx                 
    add dl,'0'            
    push dx                 
    inc cx                 
    test ax,ax             
    jnz loop1          
 
loop2:                 
    pop dx                 
    mov [di],dl            
    inc di                  
    loop loop2         
    
    mov bx, '$'
    mov [di], bx		
    
    pop bx
    pop dx
    pop cx
    pop ax
    ret
convert_to_eight_str ENDP


eight_str_convert proc FAR
    push di
    push cx
    push bx
    push dx

    mov di, offset eight_str
    mov dx, '$'

    xor bx,bx
    metka1:
        cmp [di+bx], dx
        je metka2			
        inc bx
        jmp metka1
    
    metka2:
        mov cx, bx

    mov bx, 8
    mov dx, 0

    loop3:
        mul bx
        mov dl, [di]
        sub dl, '0'
        add al, dl
        inc di
    loop loop3

	mov di, offset n
    mov dx, [di]
    cmp dx, 0
    je pos_num
	
    neg ax

    pos_num:

    pop dx
    pop bx
    pop cx
    pop di
    ret
eight_str_convert endp


MAIN PROC FAR
    push DS
    xor ax,ax
    push ax
    mov ax, DATA
    mov ds, ax

    mov ax, NUMBER
    cmp ax, 0
    jge skip
    neg ax

    skip:
        call convert_to_eight_str
        push ax
        mov dx, offset eight_str
        call WriteMsg
        pop ax
        xor ax, ax
        call eight_str_convert
        ret
MAIN ENDP
CODE ENDS
    END MAIN