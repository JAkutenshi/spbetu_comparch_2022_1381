#include <iostream>
#include <fstream>
#include <windows.h>

using namespace std;

char input_string[81];
char output_string[81];
int counter = 0; // счетчик
char vowels[32]; //ћассив глассных

int main() {
	std::string str_vowels = "AEIYUOaeiyuoјџќ»я”≈®Ёёаыои€уеЄэю";
	for (int i = 0; i < 32; i++) {
		vowels[i] = str_vowels[i];
	}
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");

	cout << "¬ведите строку:";
	cin.getline(input_string, 81);

	ofstream file;
	file.open("out.txt");

	__asm {
		push ds
		pop es
		mov esi, offset input_string
		mov edx, esi // дл€ хранени€ текущего адреса исходной строки
		mov edi, offset output_string
		sub ebx, ebx

		start :
			lodsb
			cmp al, '\0'
			je finish //ѕри достижении конца строки, завершение программы

			cmp al, '0'
			jl write

			jmp start

		write:
			stosb
			mov edx, esi				
			mov esi, offset vowels
			mov bl, al // текущий символ из исходной строки

		check:
			lodsb
			cmp al, '\0'
			je f
			cmp al, bl // если не равно , следующий символ массива будем сравнивать
			jne check
			add counter, 1
			jmp check

		f:
			mov esi, edx //воращаемс€ к текущей позиции в исходной строке
			jmp start

		finish :
	};

	cout << " оличество гласных:";
	cout << counter;
	file << output_string;
	file.close();
	return 0;
}