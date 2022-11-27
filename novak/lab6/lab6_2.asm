.586p
.MODEL FLAT, C
.CODE
function PROC C USES EDI ESI, array:dword, len:dword, LGrInt:dword, NInt:dword, answer:dword

push eax
push ebx
push ecx
push edi
push esi

mov ecx, len
mov esi, array
mov edi, LGrInt
mov eax, 0

ans:
	mov ebx, 0 ;текущее количество пройденных интервалов
	count:
 	 cmp ebx, NInt ;сравнение ebx и кол-ва интервалов разбиения
	 jge out ;сли >= выходим в другой блок

	 push eax
	 mov eax, [esi + 4 * eax] ;в eax кладутся поочерёдно элементы массива, масшт на 4 в силу размера
	 cmp eax, [edi + 4 * ebx] ;сравниваются этот эл-т массива и эл-т в зависимости от кол-ва пройденных интервалов
	 pop eax ;возвращается eax
	 jl out ;если < то выходим
	 inc ebx ;иначе меняется интервал
	 jmp count ;снова идем в этот блок

	out:
	 dec ebx ;возврат к предыдущему интервалу

	 cmp ebx, -1 
	 je to_next_num ;если отрицательный идем в блок next_sum
	 mov edi, answer 
	 push eax
	 mov eax, [edi + 4 * ebx] ;помещается ebx-й по счёту эл-т в массиве результатов
	 inc eax ;+1
	 mov [edi + 4 * ebx], eax ;в ebx-ю ячейку массива рез-в помещается eax
	 pop eax
	 mov edi, LGrInt

	to_next_num:
		inc eax

loop ans

pop esi
pop edi
pop ecx
pop ebx
pop eax

ret

function ENDP
END