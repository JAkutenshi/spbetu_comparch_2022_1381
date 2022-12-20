NUM_SYM equ 5 ; кол-во символов в строке для ввода

; Стек  программы
AStack    SEGMENT  STACK
          DW 1024 DUP(?)  ; Отводится 1024 слов памяти
AStack    ENDS

; Данные программы
DATA      SEGMENT
          KEEP_CS DW 0  ; для хранения сегмента
          KEEP_IP DW 0  ; и смещения прерывания
          simbol db 0
          num db 0
          ; возврат каретки с кодом 13 (0Dh), перевод строки с кодом 10 (0Ah).
          MES DB 0Dh, 0Ah, NUM_SYM dup("$"), '$'
          MES_END DB 0Dh, 0Ah, 'Finish', '$'
DATA      ENDS

; Код программы
CODE      SEGMENT
          ASSUME CS:CODE, DS:DATA, SS:AStack

SUBR_INT  PROC FAR
          JMP start
          KEEP_SS DW 0000h
          KEEP_SP DW 0000h
          KEEP_STACK DB 40 DUP(?)
      start:
          MOV KEEP_SP, SP
          MOV KEEP_SS, SS
          MOV SP, SEG KEEP_STACK
          MOV SS, SP
          MOV SP, offset start
          
          PUSH AX  ; сохранение изменяемых регистров
          PUSH CX
          PUSH DX
                    
      print:   
	      mov dl, simbol
	      mov ah, 02h ;вывод строки
	      int 21h
	      sub num, 1
	      cmp num, 0
          	  JNE final
	      mov ah, 09h
	      mov dx, offset MES_END
	      int 21h
      final:
   	      pop ax
	      pop dx
	      pop cx
	      mov SS, KEEP_SS 
	      mov SP, KEEP_SP 
              mov AL, 20h 
              out 20h,AL 
              iret
SUBR_INT ENDP

; Головная процедура
Main            PROC  FAR
          push  DS       ;\  Сохранение адреса начала PSP в стеке
          sub   AX,AX    ; > для последующего восстановления по
          push  AX       ;/  команде ret, завершающей процедуру.
          mov   AX,DATA   ; Загрузка сегментного
          mov   DS,AX     ; регистра данных.

          mov ah, 01h
          int 21h
          mov simbol, al

          mov ah, 01h
          int 21
          sub al, 48
          mov num, al
    

          mov dl, 10
          mov ah, 02h
          int 21h
          
          ; Запоминание текущего вектора прерывания
          MOV  AH, 35H   ; функция получения вектора
          MOV  AL, 08H   ; номер вектора
          INT  21H
          MOV  KEEP_IP, BX  ; запоминание смещения
          MOV  KEEP_CS, ES  ; и сегмента
          
          ; Установка вектора прерывания
          PUSH DS
          MOV  DX, OFFSET SUBR_INT ; смещение для процедуры в DX
          MOV  AX, SEG SUBR_INT    ; сегмент процедуры
          MOV  DS, AX          ; помещаем в DS
          MOV  AH, 25H         ; функция установки вектора
          MOV  AL, 08H         ; номер вектора
          INT  21H             ; меняем прерывание
          POP  DS
          


          
          ; Восстановление изначального вектора прерывания
    iteration:    
          cmp num, 0
          JNE iteration	
    
          ;restore the old interrupt
          CLI
   	      PUSH DS
  	      MOV DX, KEEP_IP
  	      MOV AX, KEEP_CS
  	      MOV DS, AX
  	      MOV AH, 25H
  	      MOV AL, 08h
  	      INT 21H  ;восстанавливаем вектор
  	      POP DS
	      STI
	      MOV AH, 4CH
        	  INT 21H
	      RET

Main      ENDP
CODE      ENDS
          END Main