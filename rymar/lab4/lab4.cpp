#include <iostream>
#include <stdio.h>
#include <cstring>

char input_string[81];
char output_string[321];

int main() {
    std::cout << "Student: Rymar Marya\nGroup: 1381\nTask: conversion from decimal to binary\n";


    fgets(input_string, 81, stdin);
    input_string[strlen(input_string)] = '\0';

    __asm {
        push ds
        pop es
        mov esi, offset input_string
        mov edi, offset output_string

     line:
            lodsb
            cmp al, '2'
            jne digit3
            mov ax, '01'
            stosw
            jmp final

     digit3:
            cmp al, '3'
            jne digit4
            mov ax, '11'
            stosw
            jmp final

     digit4:
            cmp al, '4'
            jne digit5
            mov ax, '01'
            stosw
            mov al, '0'
            stosb
            jmp final

     digit5:
            cmp al, '5'
            jne digit6
            mov ax, '01'
            stosw
            mov al, '1'
            stosb
            jmp final

     digit6:
            cmp al, '6'
            jne digit7
            mov ax, '11'
            stosw
            mov al, '0'
            stosb
            jmp final

     digit7:
            cmp al, '7'
            jne digit8
            mov ax, '11'
            stosw
            mov al, '1'
            stosb
            jmp final

     digit8:
            cmp al, '8'
            jne digit9
            mov eax, '0001'
            stosd
            jmp final

     digit9:
            cmp al, '9'
            jne last
            mov eax, '1001'
            stosd
            jmp final

     last:
            stosb

     final:
            mov ecx, '\0'
            cmp ecx, [esi]
            ; если был найден конец, то выход
            je lineEnd
            jmp line
            lineEnd:
    };

    std::cout << output_string;
    FILE* f;
    fopen_s(&f, "output.txt", "w");
    fwrite(output_string, sizeof(char), strlen(output_string), f);

    return 0;
}
