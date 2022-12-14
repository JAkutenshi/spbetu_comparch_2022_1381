AStack  SEGMENT STACK
    DB 1024 DUP(?)
AStack  ENDS

DATA    SEGMENT
	DECIM DB 'Decimal: ', '$'
	N DW 0
    DEC_STR DB ' ', '$'
    SIGN DB ' ', '$'
    NUMBER DW 1111h
DATA    ENDS


CODE    SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack
    

WriteMsg  PROC  NEAR
          mov AH, 9
          int 21h 
          ret
WriteMsg  ENDP


Int_to_dec_str proc FAR
    push ax
    push cx
    push dx
    push bx
    xor cx,cx               
    mov bx,10               
    mov di, offset DEC_STR
 
lp1:         ;ост
    xor dx,dx               
    div bx                 
    add dl,'0'            
    push dx                 
    inc cx                  
    test ax,ax              
    jnz lp1          
 
lp2:                 
    pop dx                  
    mov [di],dl             
    inc di                  
    loop lp2          
    
    mov bx, '$'
    mov [di], bx
    
    pop bx
    pop dx
    pop cx
    pop ax
    ret
Int_to_dec_str ENDP


Dec_str_to_int proc FAR
    push di
    push cx
    push bx
    push dx

    mov di, offset DEC_STR
    mov dx, '$'

    xor bx,bx
    len:
    cmp [di+bx], dx
    je en
    inc bx
    jmp len
    en:
    mov cx, bx

    mov bx, 10
    mov dx, 0

    lp_1:
        mul bx
        mov dl, [di]
        sub dl, '0'
        add al, dl
        inc di
    loop lp_1

    mov di, offset N
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
Dec_str_to_int endp


MAIN PROC FAR
    push DS
    xor ax,ax
    push ax
    mov ax, DATA
    mov ds, ax

    mov dx, offset DECIM
    call WriteMsg

    mov ax, NUMBER
    mov di, offset SIGN
    mov bx, "+"
    cmp ax, 0
    jge set_sign
    mov bx, "-"
    neg ax
    push bx
    mov bx, 1
    mov N, bx
    pop bx

    set_sign:
        mov [di], bx
        inc di
        mov bx, '$'
        mov [di], bx

    push ax
    mov dx, offset SIGN
    call WriteMsg
    pop ax

    call Int_to_dec_str
    push ax
    mov dx, offset DEC_STR
    call WriteMsg
    pop ax

    xor ax, ax
    call Dec_str_to_int
    ret
MAIN ENDP
CODE ENDS
    END MAIN