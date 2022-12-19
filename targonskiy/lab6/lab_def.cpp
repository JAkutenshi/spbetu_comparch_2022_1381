#include <iostream>
#include <fstream>
#include <random>


extern "C" void FUNC(int* array, int array_size, int* left_boarders, int intervals_size, int* result_array, int* even_array);

int main()
{
	setlocale(LC_ALL, "ru");
	int Xmin, Xmax, NumRanDat, interval_amount;
	int* left_borders;
	int* arr;
	int* result_array;
	int* even_array;
	std::random_device rand;
	std::mt19937 gen(rand());
	std::ofstream file("out.txt");

	std::cout << "Введите кол-во псевдослучайных целых чисел: ";
	std::cin >> NumRanDat;

	std::cout << "Минимальное значение: ";
	std::cin >> Xmin;
	std::cout << "Максимальное значение: ";
	std::cin >> Xmax;

	while (Xmax < Xmin) {
		std::cout << "Некорректные границы распределения" << std::endl;
		std::cout << "Минимальное значение: " << std::endl;
		std::cin >> Xmin;
		std::cout << "Максимальное значение: " << std::endl;
		std::cin >> Xmax;
	}

	std::cout << "Введите количество интервалов: ";
	std::cin >> interval_amount;

	while (interval_amount <= 0)
	{
		std::cout << "Некорректное кол-во интервалов" << std::endl;
		std::cout << "Введите количество интервалов: " << std::endl;
		std::cin >> interval_amount;
	}

	left_borders = new int[interval_amount];
	std::cout << "Введите левые границы: ";
	for (int i = 0; i < interval_amount; i++)
		std::cin >> left_borders[i];

	for (int i = 0; i < interval_amount - 1; i++)
	{
		for (int j = i + 1; j < interval_amount; j++)
		{
			if (left_borders[j] < left_borders[i])
				std::swap(left_borders[j], left_borders[i]);
		}
	}

	std::uniform_int_distribution<> dis(Xmin, Xmax);
	arr = new int[NumRanDat];

	for (int i = 0; i < NumRanDat; i++)
		arr[i] = dis(gen);

	std::cout << "Список: ";
	file << "Список: ";
	for (int i = 0; i < NumRanDat; i++) {
		std::cout << arr[i] << ' ';
		file << arr[i] << ' ';
	}
	std::cout << '\n';
	file << '\n';

	result_array = new int[interval_amount];
	even_array = new int[interval_amount];
	for (int i = 0; i < interval_amount; i++) {
		result_array[i] = 0;
		even_array[i] = 0;
	}

	FUNC(arr, NumRanDat, left_borders, interval_amount, result_array, even_array);

	std::cout << "Индекс \tИнтервал левой границы \tКол-во значений" << "\tКоличество четных элементов" << '\n';
	file << "Индекс \tИнтервал левой границы \tКол-во значений" << "\tКоличество четных элементов" << '\n';

	for (int i = 0; i < interval_amount; i++)
	{
		std::cout << "\t" << i + 1 << "\t\t" << left_borders[i] << "\t\t\t" << result_array[i] << "\t\t\t" << even_array[i] << '\n';
		file << "\t" << i + 1 << "\t\t" << left_borders[i] << "\t\t\t" << result_array[i] << "\t\t\t" << even_array[i] << '\n';
	}

	delete[] left_borders;
	delete[] arr;
	delete[] result_array;
	file.close();
	return 0;
}