#include <iostream>
#include <random>
#include <fstream>
#include <algorithm>

extern "C" {void mod_function(int* Array, int len, int* LGrInt, int NInt, int* answer); }


void generate_array(int*& array, int length, int min, int max) {
    std::random_device seed;
    std::mt19937 gen(seed());
    std::uniform_int_distribution<int> dist{ min, max };
    for (int i = 0; i < length; i++) {
        array[i] = dist(gen);
    }

}


int main()
{
    int NumRamDat;
    int min;
    int max;
    int NInt;

    int* Array;
    int* LGrInt;

    std::cout << "Enter array size.\n";
    std::cin >> NumRamDat;

    Array = new int[NumRamDat];

    std::cout << "Enter a range number:\nFrom:";
    std::cin >> min;
    std::cout << "To:";
    std::cin >> max;

    while (min >= max) {
        std::cout << "Incorrect Xmax, input again:";
        std::cin >> max;
    }
    generate_array(Array, NumRamDat, min, max);

    std::cout << "Enter the number of split intervals:";
    std::cin >> NInt;
    while (NInt < 0 || NInt > 24) {
        std::cout << "Incorrect NInt, input again:";
        std::cin >> NInt;
    }

    LGrInt = new int[NInt];

    std::cout << "Enter intervals\n";
    for (int i = 0; i < NInt; i++)
    {
        std::cout << "Interval_Border" << i + 1 << ": ";
        std::cin >> LGrInt[i];
        while (LGrInt[i] > max || LGrInt[i] < min) {
            std::cout << "Incorrect border, input again:";
            std::cin >> LGrInt[i];
        }
    }
    std::sort(LGrInt, LGrInt + NInt);

    int* answer = new int[NInt] {0};

    mod_function(Array, NumRamDat, LGrInt, NInt, answer);

    std::cout << "\n\n";
    std::cout << "Array_Random:\n";
    for (int i = 0; i < NumRamDat; i++)
    {
        std::cout << Array[i] << " ";
    }

    std::sort(Array, Array + NumRamDat);
    std::cout << "\n\n";
    std::cout << "Array_Sorted:\n";
    for (int i = 0; i < NumRamDat; i++)
    {
        std::cout << Array[i] << " ";
    }
    std::cout << "\n\n";
    std::cout << "Index\t" << "Interval_Border\t" << "Count\n";
    for (int i = 0; i < NInt; i++) {
        std::cout << "  " << i + 1 << "\t  " << LGrInt[i] << "\t  " << answer[i] << '\n';
    }
    delete[] Array;
    delete[] LGrInt;
    delete[] answer;
}