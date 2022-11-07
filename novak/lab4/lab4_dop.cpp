#include <iostream>
#include <fstream>
#include <string>
char input_str[81];
char output_str[81];
char vowels[20];
int kol = 0;

int main() {
	std::string str = "АЕЁИОУЫЭЮЯаеёиоуыэюя";
	for (int i = 0; i < 20; i++) {
		vowels[i] = str[i];
	}

	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");

	std::cout << "Новак Полина, гр 1381.\n Задание: Исключение латинских букв и цифр, введенных во входной строке при формировании"
		"выходной строки.\n";
	std::cout << "Введите строку: ";
	std::cin.getline(input_str, 81);//считывание строки

	std::ofstream file;
	file.open("out.txt");//создание и открытие файла

	__asm {
		push ds
		pop es
		mov esi, offset input_str//адрес начала
		mov edx, esi//дгополнительно сохранение адреса начала
		mov edi, offset output_str
		sub ecx, ecx//используем для счётчик регистр
		sub ebx, ebx

		check ://проверка символов
			lodsb
			cmp al, '\0'//если конец строки, завершение программы
			je finish

			cmp al, '0'//если код символа меньше 0 идем в write
			jl write

			cmp al, 'z'//если код символа больше z идем в write
			jg write

		case1 :
			cmp al, '9'//если код символа больше 9 идем в case2
			jg case2
			jmp check

		case2 :
			cmp al, 'a'//если код символа меньше a идем в case3
			jl case3
			jmp check

		case3 :
			cmp al, 'A'//если код символа меньше A идем в write
			jl write
			cmp al, 'Z'//если код символа больше Z идем в write
			jg write
			jmp check

		write :
			stosb
			mov edx, esi//сохранение текущего состояния esi
			mov esi, offset vowels//адрес массива гласных
			mov bl, al//сохраняем символ из fl

		vowelcheck:
			lodsb//копирование гласной из массива гласных в al
			cmp al, '\0'//проверка на конец строки, если так то в endline
			je endline
			cmp al, bl//если не совпадают предыдущий и новый символы, то опять идем в repeat
			jne vowelcheck
			inc ecx//увеличение счетчика на 1
			jmp vowelcheck

		endline:// когда конец строки массива гласных
			mov esi, edx//возвращаем в esi текущее состояние начальной строки
			jmp check//продолжаем проверку символов

		finish :
			mov edi, offset kol
			mov al, cl
			stosb

	};

	std::cout << "Строка без символов русского алфавита и цифр\n";
	std::cout << output_str << '\n';
	file << output_str << '\n';
	std::cout << kol;
	file << kol;
	file.close();

	return 0;
}