#include <iostream>
#include <fstream>
#include <windows.h>

char input_str[81];//вводимая и выводимая строки
char output_str[81];

int main() {
	SetConsoleCP(1251);
	SetConsoleOutputCP(1251);


	std::cout << "Новак Полина, гр 1381.\n Задание: Исключение латинских букв и цифр, введенных во входной строке при формировании"
		"выходной строки.\n";
	std::cout << "Введите строку: ";
	std::cin.getline(input_str, 81);//считывание строки
	input_str[strlen(input_str)] = '\0';
	std::ofstream file;
	file.open("out.txt");//создание и открытие файла
	__asm {
		push ds
		pop es//адрес даты в es
		mov esi, offset input_str//адрес начала
		mov edi, offset output_str
	check://проверка символов
		lodsb
		cmp al, '\0'//если конец строки, завершение программы
			je end

		cmp al, '0'//если код символа меньше 0 идем в write
			jl write

		cmp al, 'z'//если код символа больше z идем в write
			jg write

	case1:
		cmp al, '9'//если код символа больше 9 идем в case2
			jg case2
		jmp check

	case2:
		cmp al, 'a'//если код символа меньше a идем в case3
			jl case3
		jmp check

	case3:
		cmp al,'A'//если код символа меньше A идем в write
			jl write
		cmp al,'Z'//если код символа больше Z идем в write
			jg write
		jmp check

	write://вывод символа в edi
		stosb
		jmp check

	end :
	};

	std::cout << "Итоговая строка: ";
	std::cout << output_str<<'\n';
	file << output_str;
	file.close();
	return 0;
}