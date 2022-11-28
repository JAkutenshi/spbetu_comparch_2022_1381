#include <iostream>
#include <fstream>
#include <windows.h>

char input_str[81];
char output_str[81];
short int count;

int main() {
    SetConsoleCP(1251);
    SetConsoleOutputCP(1251);


    std::cout << "*Таргонский Михаил, группа: 1381.\n*Вариант 22. Задание: Преобразование всех заглавных латинских букв входной строки в строчные, а десятичных цифр в инверсные, остальные символы входной строки передаются в выходнуюстроку непосредственно.\n";
    std::cout << "*Введите строку: ";
    std::cin.getline(input_str, 81);
    std::ofstream file;
    file.open("out.txt");
    __asm {
        push ds
        pop es
        mov esi, offset input_str
        mov edi, offset output_str
        check :
        lodsb
            cmp al, '\0'
            je finish

            cmp al, '0'
            jb writedown

            cmp al, '9'
            jbe reverse

            cmp al, 'A'
            jb writedown
            cmp al, 'Z'
            jbe save
            cmp al, 122
            ja writedown

            save :
        xor al, 20h
            jmp writedown
            reverse :
        neg al
            add al, 69h

            writedown :
        stosb
            jmp check
            finish :

        mov esi, offset output_str
        mov ebx, offset count
        mov ax, 0
        fstart:
        lodsb
        cmp al, '\0'
        je fend
        cmp al, 48
        jl fstart
        cmp al, 57
        jg fstart
        sub al, 48
        add [ebx], al
        jmp fstart
        fend:
    };
    std::cout << "*Итог: ";
    std::cout << output_str << '\n' << count;
    file << output_str;
    file.close();
    return 0;
}