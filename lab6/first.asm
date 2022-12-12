.586
.MODEL FLAT, C
.CODE
first PROC C arr:dword, NumRanDat:dword, Xmin:dword, answer_arr:dword

mov eax, arr
mov ebx, answer_arr
mov ecx, NumRanDat
xor edx, edx
xor edi, edi

finding:
	mov edi, [eax + 4 * edx]		;значение
	sub edi, Xmin					;индекс
	inc dword ptr [ebx + 4 * edi]	;увеличение счетчика числа
	inc edx							;следующее значение
	loop finding					;уменьшает счётчик длины

	ret
	first endp
	end