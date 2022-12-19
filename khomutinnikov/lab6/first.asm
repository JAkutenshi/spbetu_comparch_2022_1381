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
	mov edi, [eax + 4 * edx]		
	sub edi, Xmin				
	inc dword ptr [ebx + 4 * edi]		
	inc edx					
	loop finding				

	ret
	first endp
	end