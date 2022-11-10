#include <stdio.h>
#include <stdlib.h>
#include "string.h"

int main() {
    int char_max = 80;
    int counter = 0;
    char* input = (char*) calloc(char_max, sizeof(char));

    fgets(input, char_max, stdin);
    int len = strlen(input) - 1;

    puts(" Количество не_букв в строке.");

    asm("check_letter: \n"
        "\t mov %%al, [%[inp]+%[idx]] \n"
        "\t cmp %%al, 'A' \n"
        "\t jl count \n"
        "\t cmp %%al, 'Z' \n"
        "\t jl next \n"
        "\t cmp %%al, 'a' \n"
        "\t jl count \n"
        "\t cmp %%al, 123 \n"
        "\t jl next \n"
        "\t cmp %%al, 128 \n"
        "\t jl count \n"
        "\t cmp %%al, 176 \n"
        "\t jl next \n"
        "\t cmp %%al, 224 \n"
        "\t jl count \n"
        "\t cmp %%al, 241 \n"
        "\t jg count \n"
        "\t jmp next \n"

        "count: \n"
        "\t inc %0 \n"

        "next: \n"
        "\t inc %[idx] \n"
        "\t loop check_letter \n"

        "end: \n"

            : "+r" (counter)
            : [inp] "b" (input),
              [count] "c" (len),
              [idx] "S" (0L)
            : "ax"
    );

    for (int i = 0; i < len; i++){
        printf("%d %c\n", i, input[i]);
    }

    printf("result %d\n", counter);

    free(input);

    return 0;
}
