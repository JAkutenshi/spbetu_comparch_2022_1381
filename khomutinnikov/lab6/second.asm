.586
.MODEL FLAT, C
.CODE
second PROC C arr:dword, Xmin:dword, Xmax:dword, LGrInt:dword, resultArr:dword

mov eax, Xmin 
mov edi, resultArr
mov edx, LGrInt
mov esi, arr
xor ebx, ebx
xor ecx, ecx

finding:
	cmp eax, [edx + 4]			
	jl adding					
	cmp eax, Xmax
	jg finish					
	cmp eax, Xmax
	je func						

	add edx, 4
	add edi, 4
	jmp finding

func:
	add edi, 4					
	mov ebx, [esi + ecx * 4]	
	add [edi], ebx				
	jmp finish

adding:
	mov ebx, [esi + ecx * 4]	
	add [edi], ebx				
	inc ecx						
	inc eax						
	jmp finding

finish:
	ret
	second endp
	end