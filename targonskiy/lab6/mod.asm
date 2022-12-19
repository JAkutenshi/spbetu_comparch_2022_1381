.586
.MODEL FLAT, C
.CODE
FUNC PROC C array:dword, array_size:dword, left_borders:dword, interval_amount:dword, result_array:dword
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
	mov ebx, 0
	borders:
 		cmp ebx, interval_amount
		jge borders_exit
		push eax
		mov eax, [esi+4*eax]
		cmp eax, [edi+4*ebx]
		pop eax
		jl borders_exit
		inc ebx
		jmp borders
	borders_exit:
	dec ebx

	cmp ebx, -1
	je skip
	mov edi, result_array
	push eax
	mov eax, [edi+4*ebx]
	inc eax
	mov [edi+4*ebx], eax
	pop eax
	mov edi, left_borders
	skip:
	inc eax
loop l1

pop ebx
pop eax
pop edi
pop esi
pop ecx
ret
FUNC ENDP
END