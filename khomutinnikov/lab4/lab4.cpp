#include <iostream>
#include <stdio.h>
#include <clocale>

using namespace std;

#define N 80

char input_str[N];
char output_str[2*N];

int main()
{
	setlocale(LC_ALL, "cp866");

	cout << "\t" << "Variant 1. Khomutinnikov Nikita" << endl;
	cout << "\t" << "Forming an output string from digits and russian letters of input string" << endl;
	
	cout << "Input string: ";
	fgets(input_str, N, stdin);

	__asm {

		push ds
		pop es
		mov esi, offset input_str
		mov edi, offset output_str

		rewrite:
		lodsb
			cmp al, 32
			jne first
			stosb
			jmp final

			first:
		cmp al, 48
			jb final
			cmp al, 57
			ja second
			stosb
			jmp final

			second:
		cmp al, 128
			jb final
			cmp al, 175
			ja third
			stosb
			jmp final

			third:
		cmp al, 224
			jb final
			cmp al, 241
			ja final
			stosb
			ja final

			final:
		mov  ecx, '\0'
			cmp  ecx, [esi]
			je   rewrite_exit;
		jmp  rewrite
			rewrite_exit :
	};

	cout << "Output string: " << output_str << endl;

	return 0;
}