interrupt EQU 08h
tone EQU 10
duration EQU 200

ASTACK SEGMENT STACK
  DB 2048 DUP(?)
ASTACK ENDS

DATA SEGMENT

keep_cs DW 0    
keep_ip DW 0    
check DW 300

DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:ASTACK

MAIN PROC FAR
    push ds                      
    xor ax, ax                  
    push ax                     
    mov ax, DATA                
    mov ds, ax                  
    call REPLACE

repeat:
    cmp BYTE PTR [check], 0
    jne repeat             
    call RESTORE
    ret
MAIN ENDP

SOUND_ON PROC FAR
    push ax
    push cx
    mov al, 20h
    out 20h, al
    dec WORD PTR [check]
    mov al, tone            
    out 42h, al             
    in al, 61h              
    or al, 00000011b        
    out 61h, al             
    mov cx, duration   

sound:
    loop sound              
    and al, 11111100b       
    out 61h, al             
    pop cx
    pop ax
    iret
SOUND_ON ENDP

RESTORE PROC NEAR
    push dx
    push ax

    cli                         
    push ds                      
    mov  dx, keep_ip             
    mov  ax, keep_cs            
    mov  ds, ax                 
    mov  ah, 25h                 
    mov  al, interrupt       
    int  21h                     
    pop  ds                     
    sti                          

    pop ax
    pop dx
    ret
RESTORE ENDP

REPLACE PROC NEAR    
    push ax
    push dx

    mov  ah, 35h                
    mov  al, 1ch                
    int  21h                    
    mov  keep_ip, bx            
    mov  keep_cs, es            

    push ds                     
    mov  dx, OFFSET sound_on   
    mov  ax, SEG sound_on       
    mov  ds, ax                
    mov  ah, 25h                
    mov  al, interrupt       
    int  21h                    
    pop  ds                     

    pop dx
    pop ax
    ret
REPLACE ENDP
CODE ENDS
END MAIN