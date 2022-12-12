.686
.MODEL FLAT, C 
.CODE

PUBLIC C func
func PROC C intervals: dword, N_int: dword, N: dword, numbers: dword, final_answer: dword
	push esi
	push edi
	push eax
	push ebx
	push ecx
	push edx

	mov esi, numbers ;массив сгенерированных чисел
	mov edi, final_answer ;итоговый масссив
	mov eax, 0 ;количество пройденных символов в сгенерированном массиве

	start:
		mov ebx, [esi + 4*eax] ;текущее число из массива сгенерированных чисел
		push esi
		mov ecx, N_int ;количество, просмотренных диапазонов

		mov esi, intervals 
		cmp [esi + 4*ecx], ebx ;если число находится между правой границей и макс границей диапазона
		jl finish 
		dec ecx 

		border: ;цикл проверки для нахождения нужного диапазона(выполняется пока не будет найден нужный)
			cmp ebx, [esi + 4*ecx] ; если взятое число больше следующей левой границы
			jge print ;переход к записи
			dec ecx ; вычитаем от количества интервалов один
			jmp border 

		print: ;запись в итоговый массив
			mov esi, final_answer
			mov ebx, [esi + 4*ecx] ;берем число из итогового массива

			inc ebx ;увеличиваем на один число из итогового массива
			mov [edi + 4*ecx], ebx ;кладем обратно

		finish:
			pop esi
			inc eax ;увеличиваем на один
			cmp eax, N ;если весь массив чисел обработан (количество чисел)
			jne start ;если нет продолжаем проходить по массиву чисел

	pop edx
	pop ecx
	pop ebx
	pop eax
	pop edi
	pop esi
ret
func ENDP
END
