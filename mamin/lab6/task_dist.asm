.586p
.MODEL FLAT, C
.CODE
task_dist PROC C USES EDI ESI, numbers:dword, n:dword, intervals:dword, result3:dword, n_int:dword

push eax
push ebx
push ecx
push edi
push esi

mov esi, numbers
mov ecx, n
mov edi, intervals
mov eax, 0

run: 
	mov ebx, 0
	next_border:
 		cmp ebx, n_int
		jge previous_border
		push eax
		mov eax, [esi + 4 * eax]
		cmp eax, [edi + 4 * ebx]
		pop eax
		jl previous_border
		inc ebx
		jmp next_border

	previous_border:
		dec ebx
		cmp ebx, -1
		je next_num
		mov edi, result3
		push eax

		push edx
		mov edx, eax
		mov eax, [edi + 4 * ebx]
		push eax
		mov eax, [esi + 4 * edx]
		test eax, 1
		pop eax
		jnz task_end
		inc eax
		task_end:


		mov [edi + 4 * ebx], eax

		pop edx
		pop eax
		mov edi, intervals


	next_num:
		inc eax

loop run

pop esi
pop edi
pop ecx
pop ebx
pop eax

ret

task_dist ENDP
END
