#include <iostream>
#include <fstream>
#include <string>
#include <random>
#include <locale>

using namespace std;

extern "C" void func(int* intervals, int N_int, int N, int* numbers, int* final_answer);

int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");

	int N, X_min, X_max, N_int;

	cout << "Введите количество чисел:";
	cin >> N;
	cout << "Введите диапазон:";
	cin >> X_min >> X_max;
	cout << "Введите количество интервалов:";
	cin >> N_int;

	if (N_int <= 0 || N_int > 24) {
		cout << "Количество интервалов не соответсвует\n";
		system("Pause");
		return 0;
	}

	cout << "Введите левые диапазоны:";
	auto intervals = new int[N_int + 1];
	for (int i = 0; i < N_int; i++)
		cin >> intervals[i];


	auto numbers = new int[N];
	random_device rd;
	mt19937 generator(rd());
	uniform_int_distribution<> dist(X_min, X_max);
	for (int i = 0; i < N; i++) {
		numbers[i] = dist(generator);
		cout << numbers[i] << " ";
	}

	cout << endl;

	auto final_answer = new int[N_int];

	for (int i = 0; i < N_int; i++)
		final_answer[i] = 0;

	func(intervals, N_int, N, numbers, final_answer);

	ofstream file("output.txt");
	auto str = "Индекс интервала\tИнтервал левой границы\tКоличество чисел в интервале";
	file << str << endl;
	cout << str << endl;

	for (int i = 0; i < N_int; i++) {
		auto str_result = to_string(i + 1) + "\t\t\t" + to_string(intervals[i]) + "\t\t\t\t" + to_string(final_answer[i]) + "\n";
		file << str_result;
		cout << str_result;
	}

	system("Pause");

	return 0;
}
