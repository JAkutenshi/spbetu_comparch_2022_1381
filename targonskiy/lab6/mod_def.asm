.586
.MODEL FLAT, C
.CODE
FUNC PROC C array:dword, array_size:dword, left_borders:dword, interval_amount:dword, result_array:dword, even_array:dword
push ecx
push esi
push edi
push eax
push ebx

mov ecx, array_size
mov esi, array
mov edi, left_borders
mov eax, 0
l1:
	mov ebx, 0; обнуляем ebx для записи кол-ва интервалов
	borders:
 		cmp ebx, interval_amount; Если ebx больше либо равно кол-ву интервалов
		jge borders_exit; То выходим
		push eax
		mov eax, [esi+4*eax]; Кладём в eax элемент из array
		cmp eax, [edi+4*ebx]; Сравниваем элемент массива и один из left_borders
		pop eax
		jl borders_exit; Если элемент меньше левой границы, то выходим
		inc ebx; Берём следующий интервал
		jmp borders
	borders_exit:
	dec ebx; Возвращаемся на предыдущий интервал

	cmp ebx, -1; Если ebx равен -1, то элемент не принадлежит не одному из интервалов
	je skip; Если ebx >= 0, то элемент принадлежит какому-либо интервалу 
	mov edi, result_array; Соответствующий элемент результирующего массива увеличиваем на 1
	push eax
	mov eax, [edi+4*ebx]
	inc eax
	mov [edi+4*ebx], eax
	pop eax
	push eax
	mov edi, even_array
	mov eax, [esi + 4 * eax]
	test eax, 1
	jnz not_even
	mov eax, [edi+4*ebx]
	inc eax
	mov [edi+4*ebx], eax
	not_even:
	pop eax
	mov edi, left_borders
	skip:
	inc eax; Следующий элемент массива
loop l1; Пока ecx(Размер массива) != 0

pop ebx
pop eax
pop edi
pop esi
pop ecx
ret
FUNC ENDP
END