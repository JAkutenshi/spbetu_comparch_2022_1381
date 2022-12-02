.586
.MODEL FLAT, C
.CODE
second PROC C arr:dword, result:dword, L_array:dword, Xmin:dword, Xmax:dword

;arr - массив количества всех цифр на единичном отрезке
;result - конечный массива
;L_array - массив левых границ
;Xmin - начальное значение отрезка
;Xmax - конечное значение отрезка

mov eax, Xmin ; значение на отрезке
xor ebx, ebx
xor ecx, ecx
mov edi, result
mov edx, L_array
mov esi, arr

cycle:
	cmp eax, [edx + 4] ;если точка вышла за границы первого отрезка
	jge adding ;переход на новый отрезок

mov ebx, [esi + ecx * 4] ;количество цифр 
add[edi], ebx ;добавление к отрезку
inc ecx ;счетчик дл€ массива количества цифр
inc eax ;cледующа€ цифра

cmp eax, Xmax
jle cycle
jmp finish

adding:
	add edi, 4 ;следующа€ €чейка конечного массива
	add edx, 4 ;следующа€ граница
	jmp cycle

finish:
	ret
	second endp
	end
