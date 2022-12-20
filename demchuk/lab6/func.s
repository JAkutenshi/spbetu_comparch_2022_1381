.global func

# rdi arr
# rsi LGrInt
# rdx NInt
# rcx NumRanDat
# r8  res
# r9  res2

func:
	push rdx
	sub edx, 1
start:
	mov eax, 1
next_elem:	
	mov ebx, [rdi][rcx*4-4]
next_border:
	cmp ebx, [rsi][rax*4]
	jl write
	cmp eax, edx
	je write_last_interval
	inc eax
	jmp next_border
write:
	incq [r8][rax*4-4]
	add [r9][rax*4-4], ebx
	jmp end
write_last_interval:
	incq [r8][rax*4]
	add [r9][rax*4], ebx
end:	
	loop start
	pop rdx
	mov ecx, edx
	
srednee:
	sub edx, edx
	mov eax, [r9][rcx*4-4]		#summa
	mov ebx, [r8][rcx*4-4]		#kol-vo chisel
	cmp ebx, 0
	je end2
	cmp eax, 0
	jl negative	
	div ebx
	jmp result
negative:
	neg eax
	div ebx
	neg eax	
result:	
	mov [r9][rcx*4-4], eax
end2:
	loop srednee	

	ret
