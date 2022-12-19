#include <iostream>
#include <stdio.h>
#include <windows.h>

char in_str[81];
char out_str[81];
short int count;

int main()
{
	std::cout << "Derkacheva Darya from 1381 group\n";
	std::cout << "task 7: *convert uppercase to lowercase";
	std::cout << " *invert numbers in 8 number system" << std::endl;
	SetConsoleCP(1251); //input rus symbol
	SetConsoleOutputCP(1251);
	fgets(in_str, 81, stdin);
	in_str[strlen(in_str) - 1] = '\0';
	__asm {
		push ds
		pop es
		mov esi, offset in_str
		mov edi, offset out_str
		check :
			lodsb //use esi
			cmp al, 192 //big first
			jl not_uppercase
			cmp al, 223 //big last
			jg not_uppercase
			add al, 32 //go to lowcase
			stosb
			jmp final

		not_uppercase:
			cmp al, 'Ё' //not in ascii
			jne not_yo
			mov al, 'ё'

		not_yo :
			cmp al, 48
			jl not_between_zero_and_seven
			cmp al, 55
			jg not_between_zero_and_seven
			neg al
			add al, 103
			stosb
			jmp counting
			jmp final

		not_between_zero_and_seven:
			stosb
			jmp counting

		counting:
			mov ah, 0
			sub al, '0'
			add count, ax
			
			

		final:
			mov  ecx, '\0'
			cmp  ecx, [esi]
			je   checkExit
			jmp  check
			checkExit :
	};
	std::cout << out_str << '\n' << count;
	FILE* f;
	fopen_s(&f, "out.txt", "w");
	fwrite(out_str, sizeof(char), strlen(out_str), f);
	fclose(f);
	return 0;
}

