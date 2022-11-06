#include <iostream>
#include <fstream>
#include <windows.h>

using namespace std;

char input_string[81];
char output_string[81];

int main() {

    SetConsoleCP(1251);
    SetConsoleOutputCP(1251);

    cout << " Лабораторная работа №4; Вариант №5 \n Выполнила cтудентка группы 1381 Туркова Д.Н. \n Задание : Преобразование всех строчных латинских букв входной строки в заглавные, \n а десятичных цифр в инверсные, остальные символы входной строки передаются в выходную строку непосредственно." << endl;
    cout << " Введите строку: ";
    cin.getline(input_string, 81);

    ofstream file("out.txt");

    __asm {
        push ds
        pop es
        mov esi, offset input_string
        mov edi, offset output_string

		start : 
			cmp al, '\0'
			je finish // a==b

		character : 
		    cmp al, 'a'
			jl figure //a<b
			cmp al, 'z'
			jg figure //a>b
			sub al, 20h
			jmp final

		figure: 
			cmp al, '0'
			jl final  //a<b
			cmp al, '9'
			jg final  //a>b
			neg al;
			add al, 69h;

		final :
			stosb
			jmp start

		finish :

    };

    std::cout << "Итог: " << output_string;
    file << output_string;
    file.close();

    return 0;
}

	

