#include <iostream>
#include <fstream>
#include <windows.h>

using namespace std;

char input_string[81];
char output_string[81];

int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");

	cout << "Лабораторная работа №4; Вариант №3 \n Работу выполнила студентка группы 1381 Васильева Ольга\n Задание:Формирование входной строки только из русских и латинских букв входной строки." << endl;
	cout << "Введите строку:";
	cin.getline(input_string, 81);

	ofstream file;
	file.open("out.txt");

	__asm{
		push ds
		pop es
		mov esi, offset input_string
		mov edi, offset output_string

		start:
			lodsb
			cmp al, '\0'
			je finish //При достижении конца строки, завершение программы

			cmp al, 'a'
			jge check_low

			cmp al, 'A'
			jge check_up

			cmp al, 'А'
			jge check_rus

			cmp al, 'Ё'
			je write

			cmp al, 'ё'
			je write

			jmp start

		check_up:
			cmp al, 'Z'
			jle write
			jmp start

		check_low:
			cmp al, 'z'
			jle write
			jmp start

		check_rus:
			cmp al,'я'
			jle write
			jmp start

		write:
				stosb
				jmp start
		
		finish:
	};

	cout << "Выходная строка: ";
	cout << output_string << endl;
	file << output_string;
	file.close();
	return 0;
}