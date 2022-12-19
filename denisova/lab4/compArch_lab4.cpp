#include <iostream>

char inp_string[81];
char out_string[81];

int main()
{
    std::cout << "Student: Denisova Olga" << std::endl;
    std::cout << "Group: 1381" << std::endl;
    std::cout << "Var: 6" << std::endl;
    std::cout << "Task: inverting digits in decimal notation and converting lovercase russian letters to uppercase" << std::endl;

    fgets(inp_string, 81, stdin);
    inp_string[strlen(inp_string) - 1] = '\0';

    __asm {
        push ds
        pop es
        mov esi, offset inp_string
        mov edi, offset out_string

        read :
            lodsb
            cmp al, '0'
            jl not_digit
            cmp al, '9'
            jg not_digit
            mov bl, '9'
            sub bl, al
            add bl, '0'
            mov al, bl
            jmp save_result

        not_digit :
            cmp al, 160
            jl save_result
            cmp al, 175
            jg not_rus_1
            sub al, 32
            jmp save_result

        not_rus_1 :
            cmp al, 224
            jl save_result
            cmp al, 239
            jg not_rus_2
            sub al, 80
            jmp save_result

        not_rus_2 :
            cmp al, 241
            jne save_result
            sub al, 1

        save_result :
            stosb

        ongoing :
            cmp[esi], '\0'
            jne read

    };

    std::cout << out_string << std::endl;
    FILE* f;
    fopen_s(&f, "output.txt", "w");
    fwrite(out_string, sizeof(char), strlen(out_string), f);
    fclose(f);
    return 0;
}