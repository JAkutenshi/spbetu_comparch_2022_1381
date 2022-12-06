.586p
.MODEL FLAT, C
.CODE

func PROC C arr:dword, lenght:dword, lgi:dword, count:dword, res:dword

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

	check_num:
		cmp eax, lenght
		jge stop

		push eax
		mov eax, [esi + 4 * eax]
		cmp eax, [edi + 4 * ebx]
		jl next
		
		inc ebx
		cmp ebx, count
		jge inc_cur

		cmp eax, [edi + 4 * ebx]
		jl inc_cur
		jmp end_boarder

	inc_cur:
		inc ecx
		dec ebx
		jmp next

	end_boarder:
		dec ebx
		mov edi, res
		mov [edi + 4 * ebx], ecx
		mov edi, lgi
		mov ecx, 1
		inc ebx
		jmp next

	next:
		pop eax
		inc eax
		jmp check_num

	stop:
		mov edi, res
		mov [edi + 4 * ebx], ecx

	pop esi
	pop edi
	pop ecx
	pop ebx
	pop eax

	ret

func ENDP
END
