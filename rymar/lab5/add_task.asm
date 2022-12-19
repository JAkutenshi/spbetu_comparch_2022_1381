DATA SEGMENT
    seg_prev dw 0
    ip_prev dw 0
    message_output db 'Message output. $'
    message_final db 'FINAL MESSAGE.$'
    add_message db 'Please input correct.$'
DATA ENDS

AStack SEGMENT STACK
    dw 512 dup(?)
AStack ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack

INT_CUSTOM PROC FAR
    push ax  ;  registers storing
    push bx
    push cx  ; numbers of prints in cx
    push dx

    mov ah, 9h  ; print cx times

loop_output:
    int 21h
    loop loop_output

    mov ah, 0   ; delay
    int 1Ah
    add bx, dx

delay:
    mov ah, 0
    int 1Ah
    cmp bx, dx
    jg delay

    mov dx, offset message_final  ; final message output
    mov ah, 9h
    int 21h

    pop dx   ; restoring
    pop cx
    pop bx
    pop ax

    mov al, 20h
    out 20h, al
    iret
INT_CUSTOM ENDP

Main PROC FAR
    push ds
    sub ax, ax
    push ax
    mov ax, data
    mov ds, ax

    sub cx, cx   ; clear cx if here is trash

read_symb:
    mov dx, offset add_message  ; string output using interruption
    mov ah, 9h
    int 21h
    sub ax, ax  ; clear ax if here is trash
    int 16h   ; read digit from console
    cmp al, '1'  ; check range 1-9
    jl read_symb
    cmp al, '9'  
    jg read_symb

    sub al, 48  ; al-48, 48 - ascii '0' 
    mov cl, al  ; cx <-- num of message outputs

    mov ax, 3560h  ; previous interruption storing
    int 21h
    mov seg_prev, es
    mov ip_prev, bx

    push ds    ; custom interruption setting
    mov dx, offset int_custom
    mov ax, seg int_custom
    mov ds, ax
    mov ax, 2560h
    int 21h
    pop ds

    mov dx, offset message_output   ; setting registers using custom interruption manual
    ;mov cx, 05h   ; number of messages
    mov bx, 36h  ; delay in ticks of process /seconds/
    int 60h

    CLI   ; previous interruption restoring
    push ds
    mov dx, ip_prev
    mov ax, seg_prev
    mov ds, ax
    mov ax, 2560h
    int 21h
    pop ds
    STI

    ret

main ENDP

CODE ENDS
END Main