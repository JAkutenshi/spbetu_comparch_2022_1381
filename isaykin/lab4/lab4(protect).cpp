#include <iostream>
#include <fstream>
#include <cstdio>
char myout[161];
char myin[81];
short int sum;
int main() {
    fgets(myin, 81, stdin);
    __asm {
        push ds
        pop es
        mov esi, offset myin
        mov edi, offset myout
        take :
        lodsb
        checkA :
        cmp al, 'A'
        jne checkB
        mov ax, '01'
        jmp end
        checkB:
        cmp al, 'B'
        jne checkC
        mov ax, '11'
        jmp end
        checkC:
        cmp al, 'C'
        jne checkD
        mov ax, '21'
        jmp end
        checkD:
        cmp al, 'D'
        jne checkE
        mov ax, '31'
        jmp end
        checkE:
        cmp al, 'E'
        jne checkF
        mov ax, '41'
        jmp end
        checkF:
        cmp al, 'F'
        jne another
        mov ax, '51'
        jmp end
        another:
        stosb
        jmp check
        end:
        stosw
        check:
        cmp[esi], '\0'
        jne take
        mov al, '\0'
        stosb


        mov esi, offset myout
        mov ebx, offset sum
        mov ax, 0
        fstart:
        lodsb
        cmp al, '\0'
        je fend
        cmp al, 48 //код '0'
        jl fstart
        cmp al, 57 //код '9'
        jg fstart
        sub al, 48
        add [ebx], al
        jmp fstart
        fend:
    }
    std::cout << myout << std::endl;
    std::cout << sum << std::endl;
}