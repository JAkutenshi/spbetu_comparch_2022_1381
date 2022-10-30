#include <iostream>
#include <fstream>

char input_str[81]; // Входная строчка
int letters[26] = {0}; // Массив вхождений букв (если буква есть в строке -1 меняется на её индекс)
int counter = -1; // индекс массива letters
int len;

// Вариант 12. Формирование номера введенной латинской буквы по алфавиту
// и номера позиции его первого вхождения во входной строке и выдача их на экран.


int main() {
    std::cout << "Smirnov Dmitry group - 1381\n";
    std::cout << "Task: Forming the number of the entered Latin letter in alphabetical order\nand the position number of its first occurrence in the input string\nand displaying them on the screen.\n";
    std::cout << "Enter string:\n";
    std::cin.getline(input_str, 81);
    len = strlen(input_str);
    __asm {
            mov ax, ds
            mov es, ax
            mov esi, offset letters // адрес массива letters

            mov al, 96 // Символ перед латинской буквой 'a'
    loop_:
            mov edi, offset input_str // адрес начала строки
            mov ecx, len // записываем длинну строчки
            inc al // Ищем следующий латинский символ
            inc counter // увеличиваем индекс letters
            repne scasb // сканируем строку пока не найдем нуль-терминатор

    check_letter:
            cmp ecx, 0
            jne write_index // строка считана до конца то записываем индекс
            dec edi // проверяем прошлую букву
            cmp ES:[edi], al
            je write_index // буква = искомой, то записываем индекс
            jmp check_last_letter // провекра на последнюю букву латинского алфавита

    write_index:
            mov ebx, len // ebx = длине строки
            sub ebx, ecx // (длина строки - ecx) = индексу вхождения буквы
            mov esi, counter // берем индекс для записи
            mov ES:letters[esi * 4], ebx // записываем индекс вхождения (маштабируем в 4 раза тк массив типа int)
            jmp check_last_letter // проверяем все ли буквы пройдены

    check_last_letter:
            cmp al, 'z' // если дошли до z завершаем
            je final // метка на конец вставки
            jmp loop_ // если не последяя буква латинского языка, то заново сканируем строчку

    final:
    };
    std::fstream file;
    file.open("./answer.txt");
    for (int i = 0; i < 26; i++)
    {
        if (letters[i] != 0) {
            std::cout << i + 1 << " " << letters[i] << std::endl;
            file << i + 1 << " " << letters[i] << std::endl;
        }
    }
    file.close();
    std::cout << "Completed!\n";
    return 0;
}