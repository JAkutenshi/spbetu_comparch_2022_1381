.586p
.MODEL FLAT, C
.CODE

PUBLIC C func1		
func1 PROC C USES EDI ESI,\
ArrNumber:DWORD, QuantNumber:DWORD, ArrInter1:DWORD, Xmin:DWORD

MOV EDI, ArrNumber		       ;Адрес массива случайных чисел              
MOV ESI, ArrInter1	       ;Адрес массива счетчика чисел 
MOV ECX, QuantNumber	       ;Длина массива случайных чисел  
MOV EAX, Xmin			                                  
        
CYCLE:
	MOV EBX, [EDI]		           ;Извлечение случайного числа N
	SUB EBX, EAX	               ;Вычитание левой границы диапазона
	ADD DWORD PTR[ESI+4*EBX], 1;   ;Увеличение счетчика числа на 1
	ADD EDI, 4		               ;Переход к следующему числу
LOOP CYCLE		

RET 
func1 ENDP



PUBLIC C func2	
func2 PROC C USES EDI ESI,\                                        
ArrInter1:DWORD, ArrRightBorder:DWORD, ArrInterDif:DWORD,\
QuantBorder:DWORD, Xmin:DWORD

MOV EDI, ArrRightBorder     ;Адрес массива правых границ
MOV ESI, ArrInter1      ;Адрес массива счетчика чисел
MOV EAX, ArrInterDif    ;Адрес массива заданных интервалов
MOV ECX, QuantBorder     ;Количество разбиений (интервалов)
MOV EBX, XMIN   


XOR EDX, EDX		   

CYCLE:
	CMP EBX, [EDI]	       
	JG NEXT_RANGE	      ;Переход, если число больше текущей границы
	ADD EDX, [ESI]        ;Накопление 
	INC EBX               ;Переход к следующему числу 
	ADD ESI, 4            ;Переход к следующему элементу распр. чисел с единичным диапазоном
	JMP CYCLE
NEXT_RANGE:			      ;Достигнута правая граница интервала
	MOV [EAX], EDX        ;Помещаем в массив с заданным распр. накопленное значение
	XOR EDX, EDX          ;Обнуляем значение
	ADD EAX, 4	          ;Переход к следующем элементу массива
	ADD EDI, 4            ;Переход к следующей границе
LOOP CYCLE

RET
func2 ENDP
END
