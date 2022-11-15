#include <iostream>
#include <fstream>

char input[81];
int letters_rus[65] = {0}; 
int letters_eng[51] = { 0 };
int counter = -1; // индекс массива letters
int main() {
    //setlocale(LC_ALL, "Russian");
    std::cout << "Lutsenko Dmitry 1381.\nForming the number of the entered Russian letter alphabetically and the position number of its first occurrence in the input string and displaying them on the screen.\n";
    std::cin.getline(input, 81);

    __asm {
        push ds
        pop es
        sub ax, ax
        mov ah, 64 // Символ перед 'А'
        start:
            mov esi, offset input 
            inc ah // счётчик (на какой мы букве)
            inc counter // увеличение индекса числа
            sub ecx, ecx 
        new_symvol :
            sub al, al
            lodsb // загружаем символ в al
            inc ecx // увеличиваем кол-во считанных символов
            cmp al, '\0' 
            je check_last_symvol
        check_symvol :
            cmp al, ah
            je write_index // найден прописной символ
            cmp ah, 90
            je jump
            jmp check_last_symvol
        jump :
            add ah, 6
            jmp check_symvol
        s_e:
            mov ES : letters_rus[edi * 4], 666
            jmp start
        write_index :
            mov edi, counter
            mov ES : letters_eng[edi * 4], ecx 
            //cmp ah, 240 
            //je s_e
            jmp start // начинаем проверку новой буквы
        check_last_symvol :
            cmp ah, 'z' // если дошли до э завершаем
            je final 
            cmp al, '\0' // строка закончилась начинаем новый цикл
            je start // метка на начало цикла
            jmp new_symvol // продолжаем считывание строки

            final:
    };
    std::fstream file;
    file.open("output.txt");
    for (int i = 0; i < 51; i++)
    {
        if (letters_eng[i] != 0) {
            if (i > 25) {
                std::cout << i - 25 << " " << letters_eng[i] << std::endl;
                file << i - 25 << " " << letters_eng[i] << std::endl;
            }
            else {
                std::cout << i + 1 << " " << letters_eng[i] << std::endl;
                file << i + 1 << " " << letters_eng[i] << std::endl;
            }
        }
    }
    /*for (int i = 0; i < 26; i++) {
        if (letters_eng[i] != 0) {
            if (i > 31) {
                std::cout << i - 31 << " " << letters_eng[i] << std::endl;
                file << i - 31 << " " << letters_eng[i] << std::endl;
            }
            else {
                std::cout << i + 1 << " " << letters_eng[i] << std::endl;
                file << i + 1 << " " << letters_eng[i] << std::endl;
            }
        }
    }*/
    file.close();
    return 0;
}
