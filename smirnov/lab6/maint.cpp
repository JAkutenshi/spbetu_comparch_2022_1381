#include <iostream>
#include <random>
#include <fstream>
#include <algorithm>

extern "C" {void mod_function(int* Array, int len, int* LGrInt, int NInt, int* maximums, int* answer);}

std::ofstream file_output;

void generate_array(int*& array, int length, int min, int max) {
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

void get_data(int& NumRamDat, int*& array, int& min, int& max, int& NInt, int*& LGrInt) {
    std::cout << "Input the length of the array of pseudo-random numbers.\n";
    std::cin >> NumRamDat;

    array = new int[NumRamDat];

    std::cout << "Enter a range of random numbers:\nFrom:";
    std::cin >> min;
    std::cout << "To:";
    std::cin >> max;

    while (min >= max) {
        std::cout << "Incorrect Xmax, input again:";
        std::cin >> max;
    }
    generate_array(array, NumRamDat, min, max);
    std::sort(array, array + NumRamDat);
    std::cout << "Enter the number of split intervals:";
    std::cin >> NInt;
    while (NInt < 0 || NInt > 24) {
        std::cout << "Incorrect NInt, input again:";
        std::cin >> NInt;
    }

    LGrInt = new int[NInt];

    std::cout << "Enter intervals in ascending order\n";
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

void print_data(int NInt, int NumRamDat, int* & Array, int*& LGrInt, int*& answer, int* &maximus) {
    std::cout << "Array:\n";
    for (int i = 0; i < NumRamDat; i++)
    {
        std::cout << Array[i] << " ";
    }
    std::cout << "\n";
    file_output << "\n";
    std::cout << "Index\t" << "Border\t" << "Count\t" << "Maximum\n";
    file_output << "Index\t" << "Border\t" << "Count\t" << "Maximum\n";
    for (int i = 0; i < NInt; i++) {
        std::cout << "  " << i + 1 << "\t  " << LGrInt[i] << "\t  " << answer[i] << "\t " << maximus[i] << '\n';
        file_output << "  " << i + 1 << "\t  " << LGrInt[i] << "\t  " << answer[i] << "\t " << maximus[i] << '\n';
    }

}

int main()
{
    file_output.open("result.txt", std::ios_base::out);
    int NumRamDat;
    int Xmin;
    int Xmax;
    int NInt;

    int* Array;
    int* LGrInt;

    get_data(NumRamDat, Array, Xmin, Xmax, NInt, LGrInt);

    int* answer_arr = new int[NInt] {0};
    int* maximums = new int[NInt] {Xmin};

    mod_function(Array, NumRamDat, LGrInt, NInt, maximums, answer_arr);

    std::cout << "\n\n";

    print_data(NInt, NumRamDat, Array, LGrInt, answer_arr, maximums);

    delete[] Array;
    delete[] LGrInt;
    delete[] answer_arr;
    delete[] maximums;
    file_output.close();
}