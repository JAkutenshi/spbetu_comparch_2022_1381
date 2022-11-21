#include <iostream>
#include <stdio.h>
#include <clocale>
#include <string>

char instr[81];
char outstr[162];
char symbols[50];
char alph[66];
int count = 0;

int main()
{
	//setlocale(LC_ALL, "cp866");
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");
	std::string str = "БВГДЖЗКПРЛМНСТФХЦЧШЩЪЬЙбвгджзкпрлмнстфхцчшщъьй";
	std::string str1 = "АБВГДЕЁЖЗИЙКПРЛМНОСТУФХЦЧШЩЪЫЬЭЮЯабвгдеёжзийкпрлмностуфхцчшщъыьэюя";
	for (int i = 0; i < str.size(); i++) {
		symbols[i] = str[i];
	}
	for (int i = 0; i < str1.size(); i++)
		alph[i] = str1[i];
	std::cout << "Forming an output string only from digits and Russian letters of the input string" << "\n";
	std::cout << "Tarasov Konstantin" << "\n";
	fgets(instr, 81, stdin);
	instr[strlen(instr) - 1] = '\0';
	__asm {
		push ds
		pop es
		mov esi, offset instr
		mov edx, esi
		mov edi, offset outstr
		L :
		lodsb; копирует один байт в al
			; space(32)
			cmp al, 32
			jne skip1
			stosb
			jmp final

			; 0 - 9 (48 - 57)
			skip1:
		cmp al, 48
			jb final
			cmp al, 57
			ja skip2
			stosb
			jmp final

			; A - п(128 - 175)
			skip2:
			mov bl, al
			mov edx, esi
			mov esi, offset alph
			cycle_check:
			lodsb
			cmp al, '\0'
			je end_no
			cmp al, bl
			jne cycle_check
			mov esi, edx
			jmp final_countdown
			end_no:
			mov esi, edx
			jmp final

				final_countdown:
				stosb
				mov edx, esi
				mov esi, offset symbols
				cycle:
				lodsb
				cmp al, '\0'
				je end_loop
				cmp al, bl
				jne cycle
				add count, 1
				jmp cycle
					end_loop:
					mov esi, edx
					jmp final

			final:
		mov  ecx, '\0'
			cmp  ecx, [esi]
			je   LExit;
		jmp  L
			LExit :

	};

	std::cout << outstr << '\n';
	std::cout << count;
	FILE* f;
	fopen_s(&f, "out.txt", "w");
	fwrite(outstr, sizeof(char), strlen(outstr), f);
	return 0;
}