interruption EQU 08h
;TONE EQU 20
DURATION EQU 500

ASTACK SEGMENT STACK
  DB 2048 DUP(?)
ASTACK ENDS

DATA SEGMENT

keep_cs DW 0    ;для хранения сегмента
keep_ip DW 0    ;для смещения прерывания
check DW 300
TONE DW 100d

DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:ASTACK

MAIN PROC FAR
    push ds                      
    xor ax, ax                  
    push ax                     
    mov ax, DATA                
    mov ds, ax                  
    call REPLACEMENT

repeat:
    mov ah, 0h
    int 16h
    cmp al, '+'
    je tone_up
    cmp al, '-'
    je tone_down
    cmp al, 27   
    jne repeat
    jmp exit

tone_up:
    cmp TONE, 1000d
    je repeat
    add TONE, 100d
    jmp repeat

tone_down:
    cmp TONE, 100d
    je repeat
    sub TONE, 100d
    jmp repeat

    ;cmp BYTE PTR [check], 0
    ;jne repeat
exit:
    call RESTORE
    ret
MAIN ENDP

SUBR_INT PROC FAR
    push ax
    push cx
    mov al, 20h
    out 20h, al
    dec WORD PTR [check]
    mov al, TONE            ;Высота звука (частота)
    out 42h, al             ;Включить таймер, который будет выдавать импульсы на динамик с заданной частотой
    in al, 61h              ;Получить состояние динамика
    or al, 00000011b        ;Установить два младших бита
    out 61h, al             ;Включить динамик
    mov cx, DURATION   ;Установить длительность звука

sound:
    loop sound              ;переход, пока cx!=0
    and al, 11111100b       ;Сбросить два младших бита
    out 61h, al             ;Выключить динамик
    pop cx
    pop ax
    iret
SUBR_INT ENDP

RESTORE PROC NEAR
    push dx
    push ax

    cli                         ; Команда CLI (Clear Interrupt flag) сбрасывает флаг IF в значение 0, что запрещает прерывания
    push ds                     ; 
    mov  dx, keep_ip            ; 
    mov  ax, keep_cs            ;
    mov  ds, ax                 ;
    mov  ah, 25h                ; 
    mov  al, interruption       ;
    int  21h                    ; 
    pop  ds                     ;
    sti                         ; 

    pop ax
    pop dx
    ret
RESTORE ENDP

REPLACEMENT PROC NEAR    ;возвращает текущее значение вектора прерывания
    push ax
    push dx

    mov  ah, 35h                ; функция получения вектора, возвращает значение вектора прерывания для INT (AL)
    mov  al, 1ch                ; номер прерывания
    int  21h                    ;
    mov  keep_ip, bx            ; запоминание смещения
    mov  keep_cs, es            ; и сегмента

    push ds                     ;
    mov  dx, OFFSET subr_int    ; смещение для процедуры в DX
    mov  ax, SEG subr_int       ; сегмент процедуры
    mov  ds, ax                 ; помещаем в DS
    mov  ah, 25h                ; функция установки вектора
    mov  al, interruption       ; номер вектора
    int  21h                    ; меняем прерывание
    pop  ds                     ; Извлечение операнда из стека

    pop dx
    pop ax
    ret
REPLACEMENT ENDP
CODE ENDS
END MAIN


















