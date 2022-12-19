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
	cmp eax, [edx + 4]			;Xmin ? LGrInt
	jl adding					;1 < 2
	cmp eax, Xmax
	jg finish					;1>2
	cmp eax, Xmax
	je func						; =

	add edx, 4
	add edi, 4
	jmp finding

func:
	add edi, 4					;j++
	mov ebx, [esi + ecx * 4]	;ebx = arr[k]
	add [edi], ebx				;arrResult[j] += arr[k]
	jmp finish

adding:
	mov ebx, [esi + ecx * 4]	;ebx = arr[k]
	add [edi], ebx				;arrResult[j] += arr[k]
	inc ecx						;k++
	inc eax						;Xmin++
	jmp finding

finish:
	ret
	second endp
	end