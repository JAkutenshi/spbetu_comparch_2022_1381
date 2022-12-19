#include <iostream>
#include <random>
#include <fstream>
#include <ctime>
using namespace std;

#define NUMBER  16000		//максимальное длина числа
#define BORD  24		//максимальное количество интервалов

void get_arr(int& QuantNumber, int*& ArrNumber, int& Xmin, int& Xmax, int& QuantBorder, int*& ArrLeftBorder);
void generation(int*& ArrNumber, int QuantNumber, int min, int max);
void res_func1(int Xmin, int* ArrNumber, int QuantNumber);
void res_func2(int Xmax, int* ArrLeftBorder, int* ArrNumber, int QuantNumber);
ofstream fout("result.txt");

extern "C"
{
	void func1(int ArrNumber[], int QuantNumber, int ArrInter1[], int Xmin);
	void func2(int ArrWith1Range[], int ArrLeftBorder[], int ArrInterDif[], int QuantBorder, int Xmin);
}

int main(void) {
	setlocale(LC_ALL, "rus");

	int QuantNumber = 0; //кол-во псевдослучайных чисел
	int	Xmin = 0, Xmax = 0, MainRange = 0;
	int	QuantBorder = 0; //кол - во границ
	int* ArrNumber = NULL; 		//массив чисел
	int* ArrLeftBorder = NULL;		 //массив левых границ
	int* ArrRightBorder = NULL; //массив правых границ
	int* ArrInter1 = NULL;	//для интервалов единичной длины
	int* ArrInterDif = NULL; 	//для интервалов заданной длины

	get_arr(QuantNumber, ArrNumber, Xmin, Xmax, QuantBorder, ArrLeftBorder); // получение псевдослучайных чисел

	ArrRightBorder = new int[QuantBorder]; // создание массива правых границ, исходя из массива левых границ и граничного значения Xmax
	for (int i = 0; i < QuantBorder - 1; i++)
		ArrRightBorder[i] = ArrLeftBorder[i + 1] - 1;

	ArrRightBorder[QuantBorder - 1] = Xmax;

	MainRange = Xmax - Xmin + 1;
	ArrInter1 = new int[MainRange] {0};
	ArrInterDif = new int[QuantBorder] {0};
	func1(ArrNumber, QuantNumber, ArrInter1, Xmin); //распределение по ед. интервалам 
	func2(ArrInter1, ArrRightBorder, ArrInterDif, QuantBorder, Xmin); //распределение по опр. интервалам 
	res_func1(Xmin, ArrInter1, MainRange); 	//вывод результата первой процедуры
	res_func2(Xmax, ArrLeftBorder, ArrInterDif, QuantBorder); 	//вывод результата второй процедуры

	system("pause");
	delete[] ArrInterDif;
	delete[] ArrInter1;
	delete[] ArrNumber;
	delete[] ArrLeftBorder;
	delete[] ArrRightBorder;
	return 0;
}

void get_arr(int& QuantNumber, int*& ArrNumber, int& Xmin, int& Xmax, int& QuantBorder, int*& ArrLeftBorder)
{

	do {
		cout << "Введите количество случайных чисел, 0 < N <= " << NUMBER << ": ";
		cin >> QuantNumber;
		if (QuantNumber <= 0 || QuantNumber > NUMBER)
			cout << "\nОшибка диапазона!\n\n";
	} while (QuantNumber <= 0 || QuantNumber > NUMBER);
	ArrNumber = new int[QuantNumber];
	do {
		cout << "\nВведите диапазон случайных чисел: \n" << "	от: ";  cin >> Xmin;
		cout << "	до: ";  cin >> Xmax;
		if (Xmax <= Xmin)
			cout << "\nНеверное задание границ! Повторите попытку.\n\n";
	} while (Xmax <= Xmin);
	generation(ArrNumber, QuantNumber, Xmin, Xmax);

	do {
		cout << "\nВведите количество интервалов разбиения заданного диапазона (0 < N <= " << BORD << "): ";
		cin >> QuantBorder; cout << endl;
		if (QuantBorder <= 0 || QuantBorder > BORD)
			cout << "\nОшибка: количество интервалов не входит в указанный диапазон!Повторите попытку.\n";
	} while (QuantBorder <= 0 || QuantBorder > BORD);

	ArrLeftBorder = new int[QuantBorder];
	cout << "\nВвод интервалов по возрастанию (1-ый интервал равен левой границе)\n";
	ArrLeftBorder[0] = Xmin;	//левая граница
	cout << "Граница 1: " << Xmin << "\n";
	int tmp = 0;
	for (int i = 1; i < QuantBorder; i++)
	{
		do {
			cout << "Граница " << i + 1 << ": ";
			cin >> tmp;
			if (tmp <= ArrLeftBorder[i - 1] ) // || tmp >= Xmax
			{
				cout << "\n\nВыход за пределы диапазона!\n\n";
			}
			else
			{
				ArrLeftBorder[i] = tmp;
				break;
			}
		} while (true);
	}
	cout << "\nМассив сгенерированных чисел: ";
	for (int i = 0; i < QuantNumber; i++) {
		cout << ArrNumber[i] << " ";
	}
	cout << '\n';
}

void generation(int*& ArrNumber, int len, int min, int max)
{
	random_device rd; // класс, кот. описывает результаты ,равномерно распределенные в замкнутом диапазоне [ 0, 2^32).
	mt19937 gen(rd());
	uniform_int_distribution<> distr(min, max); //формирует равномерное распределение целых чисел в заданном интервале
	for (int i = 0; i < len; i++) {
		ArrNumber[i] = distr(gen);
	}
}

void res_func1(int Xmin, int* ArrInter1, int QuantNumber)
{
	cout << "\nРаспределение случайных чисел по интервалам единичной длины\n"; fout << "\nРаспределение случайных чисел по интервалам единичной длины\n";
	cout << "Число\tКол-во\n"; fout << "№\tЧисло\tКол-во\n";


	for (int i = 0; i < QuantNumber; i++) {
		cout << Xmin + i << "\t" << ArrInter1[i] << '\n'; fout << i + 1 << '\t' << Xmin + i << "\t" << ArrInter1[i] << '\n';
	}
}


void res_func2(int Xmax, int* ArrLeftBorder, int* ArrInterDif, int QuantNumber)
{

	cout << "\nРаспределение случайных чисел по заданным интервалам\n"; fout << "\nРаспределение случайных чисел по заданным интервалам\n";
	cout << "№\t[левая;правая гр]\tКоличество\t\n"; fout << "№\t[левая;правая гр]\tКоличество\t\n";
	for (int i = 0; i < QuantNumber; i++)
	{
		cout << i << "\t\t[" << ArrLeftBorder[i] << ";";
		fout << i << "\t\t[" << ArrLeftBorder[i] << ";";
		if (i == QuantNumber - 1)
		{
			cout << Xmax << "]"; fout << Xmax << "]";
		}
		else
		{
			cout << ArrLeftBorder[i + 1] - 1 << "]";
			fout << ArrLeftBorder[i + 1] - 1 << "]";
		}

		cout << "\t\t" << ArrInterDif[i] << '\n'; fout << "\t\t" << ArrInterDif[i] << '\n';

	}
}
