#include <stdio.h>
#include <stdlib.h>

int main() {
    int char_max = 80;
    char* input = (char*) calloc(char_max, sizeof(char));
    char* output = (char*) calloc(char_max, sizeof(char));
    FILE *file;

    scanf("%s", input);

    puts(" Преобразование всех строчных латинских букв входной строк"
         "в заглавные, а десятичных цифр в инверсные,\nостальные символы входной "
         "строки передаются в выходную строку непосредственно.");
    puts(" Авторка: Демчук Полина 1381.\n");

    asm("check_letter: \n"
        "\t mov %%al, [%[inp]+%[idx]] \n"
        "\t cmp %%al, 'a' \n"
        "\t jl check_num \n" //если не строчная латинская буква, но может быть цифрой
        "\t cmp %%al, 'z' \n"
        "\t jg result \n" //если не строчная латинская буква и не цифра
        "\t sub %%al, 32 \n" //сделать букву заглавной
        "\t jmp result \n"

        "check_num: \n"
        "\t cmp %%al, '0' \n"
        "\t jl result \n" //если не цифра
        "\t cmp %%al, '9' \n"
        "\t jg result \n" //если не цифра
        "\t mov %%ah, 105 \n" //инверсия
        "\t sub %%ah, %%al \n"
        "\t mov %%al, %%ah \n"
        "\t jmp result \n"

        "result: \n"
        "\t mov [%0+%[idx]], %%al \n"
        "\t inc %[idx] \n"
        "\t loop check_letter \n"

        "end: \n"

            : "=mr" (output)
            : [inp] "b" (input),
              [count] "c" (char_max),
              [idx] "S" (0L)
            : "ax"
    );

    file = fopen ("output.txt", "w");
    fprintf(file, "%s", output);
    fclose(file);
    printf("%s\n", output);

    return 0;
}