#include <iostream>
#include <fstream>
#include <cstdio>

char input_line[81];
char result[161];
int sum = 0;

int main() {
	std::cout << "Mamin Roman 1381. Var 9. \nConversion of decimal digits entered in the input string to the octal number system.\n";
	fgets(input_line, 81, stdin);
	input_line[strlen(input_line) - 1] = '\0';

	__asm {
		push ds
		pop es
		mov esi, offset input_line
		mov edi, offset result
		readout :
			lodsb
			cmp al, '8'
			jne check
			mov ax, '01'
			add sum, 1
			stosw
			jmp ongoing
		check :
			cmp al, '9'
			jne save_record
			mov ax, '11'
			add sum, 2
			stosw
			jmp ongoing
		digit1:
			cmp al, '1'
			jne digit2
			add sum, 1
			jmp ongoing
		digit2:
			cmp al, '2'
			jne digit3
			add sum, 2
			jmp ongoing
		digit3:
			cmp al, '3'
			jne digit4
			add sum, 3
			jmp ongoing
		digit4:
			cmp al, '4'
			jne digit5
			add sum, 4
			jmp ongoing
		digit5:
			cmp al, '5'
			jne digit6
			add sum, 5
			jmp ongoing
		digit6:
			cmp al, '6'
			jne digit7
			add sum, 6
			jmp ongoing
		digit7:
			cmp al, '7'
			jne ongoing
			add sum, 7
			jmp ongoing
		save_record:
			stosb
			jmp digit1
		ongoing :
			cmp[esi], '\0'
			jne readout
	}

	std::cout << result << std::endl;
	std::cout << sum << std::endl;
	std::ofstream outfile("asm_result.txt");
	outfile << result;
	return 0;
}