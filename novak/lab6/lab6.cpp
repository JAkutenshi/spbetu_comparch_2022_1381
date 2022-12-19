//#include"stdafx.h"
#include"iostream"
//#include<iomanip>
#include <fstream>

using namespace std;
std::ofstream file1("out.txt");

 extern "C" {void function(int* array, int len, int* LGrInt, int NInt, int* answer); }

void sort(int*arr, int count_) {
	for (int i = 0; i < count_ - 1; i++) {
		for (int j = 0; j < count_ - i - 1; j++) {
			if (arr[j] > arr[j + 1]) {
				int b = arr[j];
				arr[j] = arr[j + 1];
				arr[j + 1] = b;
			}
		}
	}
}

void print(int*arr, int count_) {
	cout << endl << endl;
	for (int j = 0; j < count_; j++) {
		cout << j + 1 << ". " << arr[j] << "\n";
	}
}

void print_task(int*& arr, int*& LGr, int count_, int length_, int*& result_final) {
	std::cout << "Array:\n";
	for (int i = 0; i < length_; i++)
	{
		std::cout << arr[i] << " ";
	}
	std::cout << "\n";
	file1 << "\n";
	cout << "Номер интервала\t Левая граница интервала   Кол-во чисел, попавших в интервал\n";
	file1 << "Номер интервала\t Левая граница интервала   Кол-во чисел, попавших в интервал\n";
	for (int j = 0; j < count_; j++) {
		cout << j + 1 << "\t\t (" << LGr[j] << ")\t\t\t   " << result_final[j] << "\n";
		file1 << j + 1 << "\t\t (" << LGr[j] << ")\t\t\t   " << result_final[j] << "\n";
	}
}

int main() {
	setlocale(0, "RUS");

	int length_; //длина массива псевдослучайных чисел

	do {
		cout << "Введите длину массива псевдослучайных чисел\n";
		cin >> length_;
	} while ((length_ > 16000) || (length_ <0));

	int Xmin, Xmax;  //левая и правая границы диапазона изменения массива

	do {
		cout << "Введите минимальное значение отрезка\n";
		cin >> Xmin;
		cout << "Введите максимальное значение отрезка\n";
		cin >> Xmax;
	} while (Xmin > Xmax);

	int*arr = new int[length_];  //массив псевдослучайных чисел

	for (int i = 0; i < length_; i++) {
		arr[i] = Xmin + rand() % (Xmax - Xmin + 1);
	};

	file1 << "Массив псевдо-случайных чисел:\n";
	for (int i = 0; i < length_; i++)
	{
		file1 << arr[i] << " ";
	}
	file1 << "\n";

	int count_;  //количество интервалов разбиения 
	do {
		cout << "Введите количество интервалов разбиения\n";
		cin >> count_;
	} while ((count_ >24) || (count_ < 1) || (count_ >(Xmax - Xmin + 1)));

	int*LGrInt = new int[count_];  //массив левых границ
	int i = 0;

	cout << "Введите левые границы интервалов разбиения\n"" 1-я граница -начало отрезка (" << Xmin << ") \n\n";
	LGrInt[i] = Xmin;
	for (int j = 1; j < count_; j++) {
		do {
			cout << "Введите " << j + 1 << "-ю границу\n";
			cin >> LGrInt[j];
		} while ((LGrInt[j] < Xmin) || (LGrInt[j] > Xmax));
	}
	sort(LGrInt, count_);

	int* result_final = new int[count_] {0};//массив результатов заполняем 0

	function(arr, length_, LGrInt, count_, result_final);

	print(LGrInt, count_);

	print_task(arr, LGrInt, count_, length_, result_final);
	system("pause");

	delete[] arr;
	delete[] LGrInt;
	delete[] result_final;
	file1.close();
	return 0;
}