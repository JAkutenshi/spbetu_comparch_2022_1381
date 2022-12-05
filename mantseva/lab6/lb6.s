.globl distribution
.type distribution, @function

distribution:

main_loop:
	mov eax, 0
	internal_loop:
		cmp eax, edx
		jge exit
		mov ebx, [rdi][rcx*4-4]
		cmp ebx, [rsi][rax*4]
		jl exit
		push rdx
		dec edx
		cmp eax, edx
		pop rdx
		je write
		cmp ebx, [rsi][rax*4 +4]
		jl write
		inc eax
		jmp internal_loop
	write:
		incq [r8 + 4*rax]
	exit: 
loop main_loop

ret
