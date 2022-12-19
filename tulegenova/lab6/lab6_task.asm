.586p
.MODEL FLAT, C
.CODE

func PROC C USES EDI ESI arr:dword, lenght:dword, lgi:dword, count:dword, res:dword, sum:dword

	push eax
	push ebx
	push ecx
	push edi
	push esi

	mov esi, arr
	mov edi, lgi
	mov eax, 0
	mov ebx, 0
	mov ecx, 0
	mov edx, 0

	check_num:
		cmp eax, lenght
		jge stop

		push eax
		mov eax, [esi + 4 * eax]
		cmp eax, [edi + 4 * ebx]
		jl skip
		
		inc ebx
		cmp ebx, count
		jge inc_cur

		cmp eax, [edi + 4 * ebx]
		jl inc_cur
		jmp end_border

	inc_cur:
		inc ecx
		dec ebx
		jmp next

	end_border:
		dec ebx
		mov edi, res
		mov [edi + 4 * ebx], ecx

		mov edi, sum
		mov [edi + 4 * ebx], edx
		mov edi, lgi

		mov edx, 0
		mov ecx, 1
		inc ebx
		jmp next

	next:
		add edx, eax 
	skip:
		pop eax
		inc eax
		jmp check_num

	stop:
		mov edi, res
		mov [edi + 4 * ebx], ecx

		mov edi, sum
		mov [edi + 4 * ebx], edx

	pop esi
	pop edi
	pop ecx
	pop ebx
	pop eax

	ret

func ENDP
END