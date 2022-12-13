.586
.MODEL FLAT, C
.CODE
task PROC C arr:dword, Xmin:dword, Xmax:dword, LGrInt:dword, resultArr:dword

mov eax, Xmin 
mov edi, resultArr
mov edx, LGrInt
mov esi, arr
xor ebx, ebx
xor ecx, ecx

finding:
	cmp eax, Xmax
	je func
	cmp eax, [edx + 4]			;Xmin ? LGrInt
	jl adding					      ;1 < 2
	add edi, 4					    ;j++
	add edx, 4
	jmp finding

func:
	mov [edi], eax			    ;arrResult[j] = eax
	jmp finish

adding:
	mov ebx, [esi + ecx * 4]
	cmp ebx, 0				      ;arr != 0
	jne countig
	inc ecx
	inc eax
	jmp finding

countig:
	mov [edi], eax
	inc ecx
	inc eax
	jmp finding
;-------------------

finish:
	ret
	task endp
	end
