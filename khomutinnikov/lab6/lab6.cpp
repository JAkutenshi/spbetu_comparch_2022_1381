#include <iostream>
#include <random>
#include <fstream>
#include <clocale>

using namespace std;
ofstream outfile;

#define MAX_SIZE 1024 * 16

extern "C" {void first(int* array, int len, int Xmin, int* result);
			void second(int* array, int Xmin, int Xmax, int* LGrInt, int* arr_out); }

void print_first(int Xmin, int Xmax, int* arr){
	cout << endl << "1st module result: " << endl;
	cout << "Interval:\t" << "Value:\t" << "Count:" << endl;
	for (int i = Xmin, j = 0; i <= Xmax; i++, j++) {
		cout << "   " << j + 1 << "\t           " << i << "\t           " << arr[j] << endl;
	}
}

void print_second(int NInt, int NumRanDat, int*& arr, int*& LGrInt, int*& answer) {
	cout << "2nd module result:" << endl;
	outfile << endl;
	cout << "Number\t" << "Left value\t" << "Count" << endl;
	outfile << "Number\t" << "Left value\t" << "Count" << endl;
	for (int i = 0; i < NInt; i++) {
		cout << "  " << i + 1 << "\t      " << LGrInt[i] << "\t          " << answer[i] << endl;
		outfile << "  " << i + 1 << "\t      " << LGrInt[i] << "\t          " << answer[i] << endl;
	}
}

int comparator(const void* a, const void* b) {
	return *(int*)a - *(int*)b;
}

int main(){

	srand(time(nullptr));

	int NumRanDat, Xmin, Xmax, NInt;
	cout << "Enter array length: ";
	cin >> NumRanDat;
	while (NumRanDat <= 0 || NumRanDat > MAX_SIZE){
		cout << "Size is incorrect, try again:";
		cin >> NumRanDat;
	}

	cout << "Enter borders of pseudonumeric array:" << endl;
	cout << "Min: ";
	cin >> Xmin;
	cout << "Max: ";
	cin >> Xmax;
	if (Xmax < Xmin)
	{
		swap(Xmin, Xmax);
		cout << "Min is greater than max. Swapping..." << endl;
	}

	int rangeLen = Xmax - Xmin + 1;
	int* arr = new int[NumRanDat];
	for (int i = 0; i < NumRanDat; i++)
		arr[i] = Xmin + rand() % rangeLen;

	cout << "Current array: ";
	for (int i = 0; i < NumRanDat; i++)
		cout << arr[i] << " ";
	cout << endl;

	qsort(arr, NumRanDat, sizeof(int), comparator);

	cout << "Sorted array: ";
	for (int i = 0; i < NumRanDat; i++)
		cout << arr[i] << " ";

	int* first_arr = new int[rangeLen] {0};
	first(arr, NumRanDat, Xmin, first_arr);
	print_first(Xmin, Xmax, first_arr);

	cout << endl << "Input number of left borders: ";
	cin >> NInt;
	while (NInt <= 0 || NInt > 24 || NInt > rangeLen)
	{
		cout << "Incorrect value. Try again: ";
		cin >> NInt;
	}

	int* LGrInt = new int[NInt + 1];
	cout << "Enter value of left borders: " << endl;
	for (int i = 0; i < NInt; i++)
	{
		std::cin >> LGrInt[i];
		while (LGrInt[i] > Xmax || LGrInt[i] < Xmin) {
			std::cout << "Value is incorrect. Try again: ";
			std::cin >> LGrInt[i];
		}
	}
	LGrInt[NInt] = Xmax + 1;

	int* second_arr = new int[NInt] {0};
	second(first_arr, Xmin, Xmax, LGrInt, second_arr);
	outfile.open("answer.txt", ios_base::out);
	print_second(NInt, NumRanDat, arr, LGrInt, second_arr);
	delete[] arr;
	delete[] LGrInt;
	delete[] first_arr;
	delete[] second_arr;
	outfile.close();

}