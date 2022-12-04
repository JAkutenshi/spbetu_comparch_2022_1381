#include <iostream>
#include <fstream>
#include <random>
#include <string>

extern "C" void module1(int* arr, int n, int* res1, int min);
extern "C" void module2(int* distr, int* interv, int min, int max, int* res2);

using namespace std;


int comp(const void* a, const void* b) {
	return (*(int*)a - *(int*)b);
}

int main() {
	setlocale(LC_ALL, "Russian");
	int n;
	int min;
	int max;
	int NInt;
	cout << "Введите количество чисел в массиве: ";
	cin >> n;
	if (n > 16000 || n <= 0) {
		cout << "Неккоректно заданный объем массива, попробуйте еще раз\n";
		return 0;
	}
	cout << "Введите минимальное значение: ";
	cin >> min;
	cout << "Введите максимальное значение: ";
	cin >> max;
	int D = max - min;
	if (D <= 0) {
		cout << "Минимальное значение не может быть больше максимального, попробуйте еще раз\n";
		return 0;
	}
	cout << "Введите число интервалов: ";
	cin >> NInt;
	if (NInt >= 24 || NInt < 1 || NInt < D + 1) {
		cout << "Неверное число интервалов, попробуйте еще раз\n";
		return 0;
	}

	int* interv = new int[NInt + 1];
	int* result_modul2 = new int[n];
	cout << "Введите " << NInt << " левых границ интервалов (чрез пробел):\n";
	for (int i = 0; i < NInt; i++) {
		cin >> interv[i];
		result_modul2[i] = 0;
	}
	qsort(interv, NInt, sizeof(int*), comp);

	if (interv[NInt] < min || interv[NInt] > max) {
		cout << "Левые границы не входят в диапозон значений, попробуйте еще раз\n";
		return 0;
	}

	random_device rd;
	mt19937 gen(rd());
	float l = float(max + min) / 2;
	float r = float(max - min) / 4;
	normal_distribution<float> conc_gen(l, r);

	interv[NInt] = max + 1;
	int* result_module1 = new int[abs(D) + 1];
	int* arr = new int[n];

	for (int i = 0; i < abs(D) + 1; i++) {
		result_module1[i] = 0;
	}

	cout << "\nСгенерированный массив чисел:" << endl;
	for (int i = 0; i < n; i++) {
		arr[i] = int(conc_gen(gen));
		cout << arr[i] << ' ';
	}
	cout << endl;

	module1(arr, n, result_module1, min);

	ofstream file("result.txt");
	string inter_res = "Промежуточный результат:\n";
	string inter_table = "L\t| Count";

	file << inter_res << inter_table << endl;
	cout << "\n" << inter_res << inter_table << endl;
	cout << "-----------------\n";
	for (int i = 0; i < abs(D) + 1; i++) {
		string res1 = (to_string(min + i) + "\t| " + to_string(result_module1[i]) + "\n");
		file << res1;
		cout << res1;
	}

	module2(result_module1, interv, min, max, result_modul2);

	string final_res = "\nРезультат работы программы:\n";
	string final_table = "N\t| L\t| Count";

	file << final_res << final_table << endl;
	cout << "\n" << final_res << final_table << endl;
	cout << "-------------------------\n";
	for (int i = 0; i < NInt; i++) {
		string res2 = (to_string(i) + "\t|" + to_string(interv[i]) + "\t|" + to_string(result_modul2[i]) + "\n");
		file << res2;
		cout << res2;
	}

	return 0;
}