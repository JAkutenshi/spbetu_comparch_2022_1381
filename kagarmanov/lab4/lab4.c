#include <stdio.h>
#include <wchar.h>
#include <locale.h>
#define LEN 80

int main() {
    setlocale(LC_ALL, "");
    wprintf(L"\t-Вариант №7. Кагарманов Данис, студент гр. 1381 \n\t-Задача: Инвертирование введенных во входной строке цифр в восьмеричной СС и преобразование заглавных русских букв в строчные, остальные символы\n\t входной строки передаются в выходную строку непосредственно.\n\nВведите строку:");
    wchar_t str[LEN];
    wchar_t new_str[LEN];
    fgetws(str, LEN, stdin);
    int size = wcslen(str);
    wcscpy(new_str, str);

    asm("while_loop:	\n"
        "cld \n"		// reset direction flag DF == 0
        "lodsd \n"		// load eax = DS:SI (copy str's wchar)
        "cmp eax, 48 \n" 	// utf8 [48;55] == 0, 1, 2, .., 7
        "jge digit_1 \n"
        "jmp write \n"
        "digit_1: \n"
        "cmp eax, 1025  \n" 	// check Ё
        "je E_case \n"
        "cmp eax, 55 \n"
        "jle digit_2 \n"

        "cmp eax, 1040 \n" 	// utf8 [1040; 1071] == А, Б, ... , Я
        "jge letter_1 \n"
        "jmp write \n"
        "letter_1: \n"
        "cmp eax, 1071 \n"
        "jle letter_2 \n"
        "jmp write \n"

        "letter_2: \n"
        "add eax, 32 \n" 	// A -> a, Б -> б ...
        "jmp write \n"

        "digit_2: \n" 		// invert_octal_digit = 48 + (55 - ascii)
        "mov edx, 55 \n" 	// edx == 55
        "sub edx, eax\n" 	// 55 - ascii
        "mov eax, 48 \n"
        "add eax, edx \n"
        "jmp write \n"

        "E_case: \n" 		// Ё -> ё, 1025 -> 1105
        "mov eax, 1105 \n"

        "write: \n"
        "mov [%[res] + %[idx]*4], eax \n"
        "inc %[idx] \n"
        "loop while_loop"
        : [res] "=m" (new_str)
        : [src] "S" (str), [idx] "b" (0L), [size] "c" (size)
       );
    wprintf(L"         Ответ:%ls",new_str);
    return 0;
}
