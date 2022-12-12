#include <iostream>
#include <random>
#include <fstream>
#include <clocale>

using namespace std;
ofstream file;

extern "C" {void first(int* array, int lenArray, int Xmin, int* arrResalt); 
			void second(int* array, int Xmin, int Xmax, int* LGrInt, int* arr_out); }

void print_first(int Xmin, int Xmax, int* arr) {
	std::cout << endl << "Результат 1 модуля: " << std::endl;
	std::cout <<"Интервал:\t" << "Значение:\t" << "Кол-во:" << std::endl;
	for (int i = Xmin, j = 0; i <= Xmax; i++, j++) {
		std::cout << "   "<<j + 1<<"\t           " << i << "\t           " << arr[j] << std::endl;
	}
}

void print_second(int NInt, int NumRanDat, int*& arr, int*& LGrInt, int*& answer) {
	std::cout << "Результат 2 модуля:" << std::endl;
	file << std::endl;
	std::cout << "Номер\t" << "Левое значение\t" << "Кол-во" << std::endl;
	file << "Номер\t" << "Левое значение\t" << "Кол-во" << std::endl;
	for (int i = 0; i < NInt; i++) {
		std::cout << "  " << i + 1 << "\t      " << LGrInt[i] << "\t          " << answer[i] << std::endl;
		file << "  " << i + 1 << "\t      " << LGrInt[i] << "\t          " << answer[i] << std::endl;
	}
}

int main()
{
	int NumRanDat, Xmin, Xmax, NInt;
	setlocale(LC_ALL, "Russian");
	cout << "Ввидите длину массива: ";
	cin >> NumRanDat;
	while (NumRanDat <= 0 || NumRanDat > 1024 * 16)
	{
		cout << "Массив неправильного размера. Введите значение ещё раз:";
		cin >> NumRanDat;
	}

	cout << "Введите диапазон изменения массива псевдослучайных целых чисел." << endl;
	cout << "Минимум: ";
	cin >> Xmin;
	cout << "Максимум: ";
	cin >> Xmax;
	if (Xmax < Xmin)
	{
		swap(Xmin, Xmax);
		cout << "Неверный ввод. Значения поменяли местами. Теперь Xmin = "<< Xmin << ", Xmax = " << Xmax;
	}

	int rangeLen = Xmax - Xmin + 1; //длина диапазона
	int* arr = new int[NumRanDat]; //массив случайных чисел
	for (int i = 0; i < NumRanDat; i++)
		arr[i] = Xmin + rand() % rangeLen;

	cout << "Исходный массив: ";
	for (int i = 0; i < NumRanDat; i++)
		cout << arr[i] << " ";

	int* arrAnswer = new int[rangeLen] {0};
	first(arr, NumRanDat, Xmin, arrAnswer);
	print_first(Xmin, Xmax, arrAnswer);

	cout << endl << "Введите количество интервалов, на которые разбивается диапазон изменения массива псевдослучайных целых чисел: ";
	cin >> NInt;
	while (NInt <= 0 || NInt > 24 || NInt>rangeLen)
	{
		cout << "Неверный ввод. Попробуй ещё раз: ";
		cin >> NInt;
	}

	int* LGrInt = new int[NInt + 1];  //массив левых границ для единичных отрезков
	LGrInt[0] = Xmin;
	cout << "Введите левые границы интервалов разбиения: " << endl;
	for (int i = 1; i < NInt; i++)
	{
		std::cin >> LGrInt[i];
		while (LGrInt[i] > Xmax || LGrInt[i] < Xmin) {
			std::cout << "Неправильное значение, попробуйте ещё раз: ";
			std::cin >> LGrInt[i];
		}
	}
	LGrInt[NInt] = Xmax + 1;

	int* resultArr = new int[NInt] {0}; 
	second(arrAnswer, Xmin, Xmax, LGrInt, resultArr);
	file.open("answer.txt", std::ios_base::out);
	print_second(NInt, NumRanDat, arr, LGrInt, resultArr);
	delete[] arr;
	delete[] LGrInt;
	delete[] resultArr;
	delete[] arrAnswer;
	file.close();
}

