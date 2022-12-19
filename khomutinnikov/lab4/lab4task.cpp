#include <iostream>
#include <stdio.h>
#include <clocale>

using namespace std;

#define N 80

char input_str[N];
char output_str[2*N];

char vows[20];
char symbols[66];

int k = 0;

int main()
{
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "RUS");

	string str1 = "ÀÅ¨ÈÎÓÛÝÞ‗או¸טמףû‎‏ÿ";
	string str2 = "ÀÁÂÃÄÅ¨ÆÇÈÉÊÏÐËÌÍÎÑÒÓÔÕÖ×ØÙÚÛÜÝÞ‗אבגדהו¸זחטיךןנכלםמסעףפץצקרשתûü‎‏ÿ";

	int i, j;

	for (i = 0; i < str1.size(); i++) vows[i] = str1[i];
	for (j = 0; j < str2.size(); j++) symbols[j] = str2[j];

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
		mov bl, al
			mov edx, esi
			mov esi, offset symbols
			if_cycle:
			lodsb
			cmp al, '\0'
			je  non_final
			cmp al, bl
			jne if_cycle
			mov esi, edx
			jmp countdown
			non_final :
			mov esi, edx
			jmp final

					countdown:
					stosb
					mov edx, esi
					mov esi, offset vows
					cycle:
					lodsb
					cmp al, '\0'
					je ending
					cmp al, bl
					jne cycle
					add k, 1
					jmp cycle
							ending:
							mov esi, edx
							jmp final

			final:
		mov  ecx, '\0'
			cmp  ecx, [esi]
			je   rewrite_exit;
		jmp  rewrite
			rewrite_exit :
	};

	cout << "Output string: " << output_str << endl;
	cout << "Vowels in output string: " << k << endl;
	return 0;
}