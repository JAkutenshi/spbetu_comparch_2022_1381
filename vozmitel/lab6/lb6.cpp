#include <iostream>
#include <ctime>
#include <windows.h>
#include <clocale>
#include <algorithm>

using namespace std;

extern "C" {
	void first(int*, int, int*, int);
	void second(int*, int*, int*, int, int);
}

void OutPut1(int* arr, int* L_arr, int NInt)
{
	cout << "\n№    Отрезок   Количество чисел" << '\n';
	for (int j = 0; j < NInt; j++)
		cout << j + 1 << "      " << L_arr[j] << " \t    " << arr[j] << '\n';
}

void OutPut2(int* arr, int* L_arr, int NInt)
{
	cout << "№    Интервал    Количество чисел" << '\n';
	for (int j = 0; j < NInt; j++)
		cout << j + 1 << "     [" << L_arr[j] << ", " << L_arr[j + 1] - 1 << "]\t\t" << arr[j]  << '\n';
}

int main()
{
	srand(time(0));
	setlocale(0, "");
	SetConsoleOutputCP(1251);
	SetConsoleCP(1251);
	int NumRanDat, Xmin, Xmax, NInt;

	cout << "Введите длину массива: ";
	cin >> NumRanDat;
	if (NumRanDat > 16 * 1024 || NumRanDat < 1)
	{
		cout << "Неверный ввод"; return 0;
	}

	cout << "Введите диапазон чисел\n";
	cout << "Мин: ";
	cin >> Xmin;
	cout << "Макс: ";
	cin >> Xmax;
	if (Xmax < Xmin)
	{
		cout << "Неверный ввод"; return 0;
	}

	int n = Xmax - Xmin + 1; //длина диапазона
	int* arr = new int[NumRanDat]; //массив случайных чисел
	for (int i = 0; i < NumRanDat; i++)
		arr[i] = Xmin + rand() % n;

	cout << endl << "Исходный массив:\n";
	for (int i = 0; i < NumRanDat; i++)
		cout << i + 1 << " значение: " << arr[i] << '\n';

	int* result = new int[n]; //массив полученного распределения едичных отрезков
	int* L = new int[n + 1];  //массив левых границ для единичных отрезков
	for (int i = 0; i < n; i++)
	{
		result[i] = 0; 
		L[i] = Xmin + i;
	}
	
	first(arr, Xmin, result, NumRanDat);
	OutPut1(result, L, n);

	cout << endl << "Введите количество интервалов разбиения: ";
	cin >> NInt;
	if (NInt > 24 || NInt < 1 || NInt > n)
	{
		cout << "Неверное количество интервалов"; return 0;
	}

	int* L_array = new int[NInt + 1];  // массив левых границ
	L_array[0] = Xmin;
	cout << "1 граница: " << Xmin << '\n';
	for (int j = 1; j < NInt; j++) {
		cout << j + 1 << " граница: ";
		cin >> L_array[j];
		if ((L_array[j] < Xmin) || (L_array[j] > Xmax))
		{
			cout << "Неверная граница";
			return 0;
		}
	}
	cout << '\n';

	int* res = new int[NInt]; // конечный массив
	for (int i = 0; i < NInt; i++)
		res[i] = 0;

	L_array[NInt] = Xmax + 1;
	second(result, res, L_array, Xmin, Xmax);
	OutPut2(res, L_array, NInt);
	return 0;

}


