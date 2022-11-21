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
        "\t lodsb \n"
        "\t cmp %%al, 208 \n"
        "\t je rus \n"
        "\t cmp %%al, 209 \n"
        "\t je rus \n"
        "\t cmp %%al, 65 \n"
        "\t jl count \n"
        "\t cmp %%al, 91 \n"
        "\t jl next \n"
        "\t cmp %%al, 97 \n"
        "\t jl count \n"
        "\t cmp %%al, 123 \n"
        "\t jl next \n"
        "\t cmp %%al, 128 \n"
        "\t jl count \n"
        "\t jmp next \n"

        "rus: \n"
        "\t lodsb \n"
        "\t sub cx, 1 \n"
        "\t jmp next \n"

        "count: \n"
        "\t inc %0 \n"

        "next: \n"
        "\t loop check_letter \n"

        "end: \n"

            : "+r" (counter)
            : [inp] "S" (input),
            "c" (len)
            : "ax"
    );

    printf("result %d\n", counter);

    free(input);

    return 0;
}
