.global module

module:
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
	jmp end
write_last_interval:
	incq [r8][rax*4]
end:	
	loop start

	ret
