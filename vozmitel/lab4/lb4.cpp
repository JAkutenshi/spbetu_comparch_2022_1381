#include <iostream>
#include <fstream>
#include <windows.h>

char input_str[81];
char output_str[81];
int main() {
    SetConsoleCP(1251);
    SetConsoleOutputCP(1251);
    

    std::cout << "*Возмитель Влас 1381.\n*Задание: Преобразование всех заглавных латинских букв входной строки в строчные, а восьмеричных цифр в инверсные, остальные символы без изменений.\n";
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

            cmp al, '7'
            jbe reverse

            cmp al, 'A'
            jb writedown
            cmp al, 'Z'
            jbe save
            cmp al, 'Z'
            ja writedown

         save:
          xor al, 20h
            jmp writedown
         reverse:
            neg al
            add al, 67h// y=7-(x-30h)+30h=67h-x
      
         writedown :
         stosb
            jmp check
         finish :
    };
    std::cout << "*Итог: ";
    std::cout << output_str;
    file << output_str;
    file.close();
    return 0;
}
