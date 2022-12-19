DATA SEGMENT
 sec db 60
 time db 0
 keep_cs dw 0 ;для хранения сегмента
 keep_ip dw 0 ;и смещения прерывания
 message DB 'Hello, enter the duration of the sound from 0 to 9.', 0dh, 0ah, '$'
 error DB 'The entered data is incorrect, please try again!', 0dh, 0ah, '$'
DATA ENDS

AStack SEGMENT STACK
 DW 512 DUP(?)
AStack ENDS

CODE SEGMENT
 ASSUME CS:CODE, DS:DATA, SS:AStack

SOUND PROC FAR ;обработка прерывания
 push ax
sound_start:
  mov al, 10110110b
  out 43h, al
  mov ax, 4400

  ;устаналиваем частоту
  out 42h, al
  mov al, ah
  out 42h, al

  ;включаем динамик
  in al, 61h ;текущее состояние порта 61h в AL
  or al, 00000011b ;устанавливаем биты 0 и 1 в 1 (разрешаем работу динамика и включить его)
  out 61h, al ;включаем динамик

inc time
timer:
  mov ah, 2ch
  int 21h
  cmp dh, sec
  je timer
  mov sec, dh
  dec time
  jnz timer

sound_end:;выключаем динамик
  in al, 61h
  and al, 11111100b ;обнуляем младшие два бита
  out 61h, al 
  pop ax
  mov al, 20h
  out 20h, al
  iret
SOUND ENDP


Main PROC FAR
 push ds
 sub ax, ax
 push ax
 mov ax, DATA
 mov ds, ax

 mov dx, offset message
 mov ah, 09h
 int 21h
 mov dx, offset error

read_time:
 mov ah, 09h
 int 21h
 mov ah, 0
 int 16h
 cmp al, '0'
 jb read_time
 cmp al, '9' 
 jg read_time
 mov time, al
 sub time,'0'
 
;cmp time,0
; jne read_symbol

read_symbol:
 mov ah, 0
 int 16h
 cmp al, 3
 jne read_symbol
 
 mov ax, 3523h
 int 21h
 mov keep_ip, bx ;запоминание смещения
 mov keep_cs, es ;и сегмента
 push ds
 mov dx, offset SOUND ;смещение для процедура в DX
 mov ax, seg SOUND ;сегмент процедуры
 mov ds, ax ;помещаем в DS
 mov ah, 25h ;функция установки вектора
 mov al, 23h ;номер вектора
 int 21h ;меняем прерывание
 pop ds
 int 23h ;вызов прерывания

 CLI;восстанавливаем старый вектор прерывания
 push ds
 mov dx, keep_ip
 mov ax, keep_cs
 mov ds, ax
 mov ah, 25h
 mov al, 23h
 int 21h ;восстанавливаем вектор
 pop ds
 STI
 RET
	
Main ENDP
CODE ENDS
END Main