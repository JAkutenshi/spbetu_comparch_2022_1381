.586p
.MODEL FLAT, C
.CODE
border_function PROC C USES EDI ESI, array:dword, len:dword, LGrInt:dword, NInt:dword, answer:dword, sums:dword

	push eax
	push ebx
	push ecx
	push edi
	push esi

	mov ecx, len
	mov esi, array
	mov edi, LGrInt
	mov eax, 0

loop1:
	mov ebx, 0
	find_border:
 		cmp ebx, NInt
		jge out_of_border

		push eax
		mov eax, [esi + 4 * eax]
		cmp eax, [edi + 4 * ebx]
		pop eax
		jl out_of_border
		inc ebx
		jmp find_border

	out_of_border:
		dec ebx

		cmp ebx, -1
		je to_next_num
		mov edi, answer
		push eax
		mov eax, [edi + 4 * ebx]
		inc eax
		mov [edi + 4 * ebx], eax
		pop eax

		push eax
		
		mov edi, sums
		mov eax, [esi + 4 * eax]
		add [edi + 4 * ebx], eax
		
		pop eax
		mov edi, LGrInt
	to_next_num:
		inc eax

loop loop1

pop esi
pop edi
pop ecx
pop ebx
pop eax

ret

border_function ENDP
END