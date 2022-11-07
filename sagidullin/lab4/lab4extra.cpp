#include <iostream>
#include <fstream>
#include <cstdio>

char input[81];
char output[162];
short int count = 0;

int main() {

	std::cout << "Sagidullin Ernest 1381.\nReplace the Latin letters entered in the input string with decimal numbers, corresponding to their alphabetical number\n";
	std::cin.getline(input, 81);

	__asm {
        push ds
        pop es
        mov esi, offset input
        mov edi, offset output
        read :
            lodsb
            cmp al, '\0'
            je end

            cmp al, '0'
            jl write

            cmp al, '9'
            jle write_num
   
            cmp al, 'A'
            jl write
   
            cmp al, 'Z'
            jle write2

            cmp al, 'a'
            jl write

            cmp al, 'z'
            jle write1

        write :
            stosb
            jmp read

        write_num:
            mov ch, 0
            sub al, '0'
            mov cl, al
            add count, cx
            add al, '0'
            jmp write


        write1 :
            and al, 5FH

        write2 :
            cmp al, 'J'
            jge write3
            sub al, 'A'
            add al, 31h
            jmp write

        write3 :
            cmp al, 'T'
            jge write4
            mov ah, al
            sub ah, 'J'
            add ah, 30h
            mov al, '1'
            stosw
            jmp read

        write4 :
            mov ah, al
            sub ah, 'T'
            add ah, 30h
            mov al, '2'
            stosw
            jmp read
         end :
           

	}

	std::cout << output <<'\n' << count;
	std::ofstream file;
	file.open("output.txt");
	file << output;
	file.close();

	return 0;
}