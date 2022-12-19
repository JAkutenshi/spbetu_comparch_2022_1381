#include <iostream>
#include <random>
#include <fstream>
#include <algorithm>

extern "C" {void FUNC(int* Array, int len, int* LGrInt, int NInt, int* answer, int* subs); }

std::ofstream file_output;

void generateArr(int*& array, int length, int min, int max) {
    std::random_device seed;
    std::mt19937 gen(seed());
    std::uniform_int_distribution<int> dist{ min, max };
    for (int i = 0; i < length; i++) {
        array[i] = dist(gen);
    }

    file_output << "Pseudo-random array:\n";
    for (int i = 0; i < length; i++)
    {
        file_output << array[i] << " ";
    }
    file_output << "\n";
}

void inputDate(int& Length, int*& array, int& min, int& max, int& NInt, int*& LGrInt) {
    std::cout << "Input the length of the array:";
    std::cin >> Length;

    array = new int[Length];

    std::cout << "Input a range of random numbers:\nFrom:";
    std::cin >> min;
    std::cout << "To:";
    std::cin >> max;

    while (min >= max) {
        std::cout << "Incorrect Xmax, input again:";
        std::cin >> max;
    }
    generateArr(array, Length, min, max);

    std::cout << "Input the number of split intervals:";
    std::cin >> NInt;
    

    LGrInt = new int[NInt];
    std::cout << "Please input border in ascending order\n";
    for (int i = 0; i < NInt; i++)
    {
        std::cout << "Border" << i + 1 << ": ";
        std::cin >> LGrInt[i];
        while (LGrInt[i] > max || LGrInt[i] < min) {
            std::cout << "Incorrect border, input again:";
            std::cin >> LGrInt[i];
        }
    }
    std::sort(LGrInt, LGrInt + NInt);
}

void printAnswer(int NInt, int NumRamDat, int*& Array, int*& LGrInt, int*& answer, int*& subs) {
    std::cout << "Array:\n";
    for (int i = 0; i < NumRamDat; i++)
    {
        std::cout << Array[i] << " ";
    }
    std::cout << "\n";
    file_output << "\n";
    std::cout << "Index\t" << "Border\t" << "Count\n";
    file_output << "Index\t" << "Border\t" << "Count\n";
    /*for (int i = 0; i < NInt; i++) {
        std::cout << "  " << i + 1 << "\t  " << LGrInt[i] << "\t  " << answer[i] << '\n';
        file_output << "  " << i + 1 << "\t  " << LGrInt[i] << "\t  " << answer[i] << '\n';
    }*/
    for (int i = 0; i < NInt; i++) {
        std::cout << "  " << i + 1 << "\t  " << LGrInt[i] << "\t  " << subs[i] << '\n';
        file_output << "  " << i + 1 << "\t  " << LGrInt[i] << "\t  " << subs[i] << '\n';
    }

}

int main()
{
    file_output.open("result.txt", std::ios_base::out);
    int Length, Xmin, Xmax, Nint;
    int* Array;
    int* LGrInt;
    inputDate(Length, Array, Xmin, Xmax, Nint, LGrInt);
    int* answer_arr = new int[Nint] {0};
    int* subs = new int[Nint] {0};
    FUNC(Array, Length, LGrInt, Nint, answer_arr, subs);
    printAnswer(Nint, Length, Array, LGrInt, answer_arr, subs);
    file_output.close();
}