#include <iostream>
#include <stdio.h>
#include <cstring>

char input_string[81];
char output_string[321];
int count0 = 0;
int count1 = 0;
char result;

int main() {
    std::cout << "Student: Rymar Marya\nGroup: 1381\nTask: conversion from decimal to binary\n";


    fgets(input_string, 81, stdin);
    input_string[strlen(input_string)-1] = '\0';

    __asm {
        push ds
        pop es
        mov esi, offset input_string
        mov edi, offset output_string

        line :
        lodsb
            cmp al, '2'
            jne digit3
            mov ax, '01'
            add count1, 1
            add count0, 1
            stosw
            jmp final

            digit3:
        cmp al, '3'
            jne digit4
            mov ax, '11'
            add count1, 2
            stosw
            jmp final

            digit4 :
            cmp al, '4'
            jne digit5
            mov ax, '01'
            stosw
            mov al, '0'
            add count1, 1
            add count0, 2
            stosb
            jmp final

            digit5:
        cmp al, '5'
            jne digit6
            mov ax, '01'
            stosw
            mov al, '1'
            stosb
            add count1, 2
            add count0, 1
            jmp final

            digit6:
        cmp al, '6'
            jne digit7
            mov ax, '11'
            stosw
            mov al, '0'
            stosb
            add count1, 2
            add count0, 1
            jmp final

            digit7:
        cmp al, '7'
            jne digit8
            mov ax, '11'
            stosw
            mov al, '1'
            stosb
            add count1, 3
            jmp final

            digit8:
        cmp al, '8'
            jne digit9
            mov eax, '0001'
            add count1, 1
            add count0, 3
            stosd

            jmp final

            digit9 :
            cmp al, '9'
            jne last
            mov eax, '1001'
            stosd
            add count1, 2
            add count0, 2
            jmp final

            last :    // 1, 0 или space (мб new line если введено меньше 80 символов)
            cmp al, '1'
            je add_count1
            cmp al, '0'
            je add_count0
            stosb
            jmp final

            add_count0:
            add count0, 1
            stosb
            jmp final

            add_count1:
            stosb
            add count1, 1
            jmp final

            final:
            mov ecx, '\0'
            cmp ecx, [esi]
            ; если был найден конец, то выход
            je lineEnd
            jmp line
            lineEnd :

            mov eax, count0
            cmp eax, count1
            mov cl, '='
            je final_result
            mov cl, '1'
            jl final_result
            mov cl, '0'

            final_result:
            mov result, cl
    };

    std::cout << output_string << '\n';
    std::cout << "count1 = " << count1 << '\n';
    std::cout << "count0 = " << count0 << '\n';
    std::cout << "result " << result << '\n';
    FILE* f;
    fopen_s(&f, "output.txt", "w");
    fwrite(output_string, sizeof(char), strlen(output_string), f);

    return 0;
}