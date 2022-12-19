#include <iostream>
#include <random>
#include <stdlib.h>
#include <fstream>
#include <algorithm>

extern "C" {void border_function(int* Array, int len, int* LGrInt, int NInt, int* answer, int* sums); }

namespace {
    auto randomizer = std::mt19937(std::random_device{}());

    int rand_int(int from, int to) {
        return std::uniform_int_distribution<int>(from, to)(randomizer);
    }

    void qsortRecursive(int* mas, int size) {
        int i = 0;
        int j = size - 1;
        int mid = mas[size / 2];
        do {
            while (mas[i] < mid) {
                i++;
            }
            while (mas[j] > mid) {
                j--;
            }
            if (i <= j) {
                int tmp = mas[i];
                mas[i] = mas[j];
                mas[j] = tmp;

                i++;
                j--;
            }
        } while (i <= j);

        if (j > 0) {
            qsortRecursive(mas, j + 1);
        }
        if (i < size) {
            qsortRecursive(&mas[i], size - i);
        }
    }

}

 
int main()
{
    int NumRamDat;
    int Xmin;
    int Xmax;
    int NInt;
    int* Array;
    int* LGrInt;

    std::cout << "Vvedite kolichestvo elementov massiva randomnih chisel: ";
    std::cin >> NumRamDat;
    Array = new int[NumRamDat];

    std::cout << "Vvedite promejutok randoma\nOt: ";
    std::cin >> Xmin;
    std::cout << "Do: ";
    std::cin >> Xmax;

    if (Xmin >= Xmax) {
        std::cout << "Nepravilnoe max ;(";
        return 0;
    }

    for (int i = 0; i < NumRamDat; i++) Array[i] = rand_int(Xmin, Xmax);


    std::cout << "Vvedite kolichestvo intervalov: ";
    std::cin >> NInt;

    if (NInt < 0 || NInt > 24) {
        std::cout << "Nepravilnoe kolichestvo ;(";
        return 0;
    }

    LGrInt = new int[NInt];

    std::cout << "Vvedite intervali v luobom poryadke\n";
    for (int i = 0; i < NInt; i++)
    {
        std::cout << "Interval" <<" #" << i + 1 << ": ";
        std::cin >> LGrInt[i];
        if (LGrInt[i] > Xmax || LGrInt[i] < Xmin) {
            std::cout << "Nepravilnoe interval";
            return 0;
        }
    }

    qsortRecursive(LGrInt, NInt);

    int* answer = new int[NInt] {0};
    int* sums = new int[NInt] {0};

    border_function(Array, NumRamDat, LGrInt, NInt, answer, sums);

    std::cout << "\n";
    std::cout << "Massiv:\n";

    qsortRecursive(Array, NumRamDat);

    int j = 0;
    int split = answer[j];
    if(NInt != 0) std::cout <<"| ";
    for (int i = 0; i < NumRamDat; i++) {
        if (i+1 < split || NInt ==0) std::cout << Array[i] << " "; 
        else { 
            j++;
            split += answer[j];
            std::cout << Array[i] << " | "; 
        }
    }


    std::cout << "\n\n";
    std::cout << "Indeks " << "Interval " << "Kolichestvo "<< "Summa" << std::endl;

    for (int i = 0; i < NInt; i++) std::cout << "  " << i + 1 << "\t  " << LGrInt[i] << "\t  " << answer[i] << "\t  "<< sums[i]<<'\n';
    

}