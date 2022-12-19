#include <iostream>
#include <fstream>
#include <random>


extern "C" void FUNC(int* array, int array_size, int* left_boarders, int intervals_size, int* result_array);

int main()
{
	int Xmin, Xmax, NumRanDat, interval_amount;
	int* left_borders;
	int* arr;
	int* result_array;
	std::random_device rand;
	std::mt19937 gen(rand());
	std::ofstream file("out.txt");

	std::cout << "Amount of numbers:" << std::endl;
	std::cin >> NumRanDat;

	std::cout << "Min: " << std::endl;
	std::cin >> Xmin;
	std::cout << "Max: " << std::endl;
	std::cin >> Xmax;

	while (Xmax < Xmin) {
		std::cout << "Wrong!" << std::endl;
		std::cout << "Min: " << std::endl;
		std::cin >> Xmin;
		std::cout << "Max" << std::endl;
		std::cin >> Xmax;
	}

	std::cout << "Amount of intervals: " << std::endl;
	std::cin >> interval_amount;

	while (interval_amount <= 0)
	{
		std::cout << "Wrong!" << std::endl;
		std::cout << "Amount of intervals: " << std::endl;
		std::cin >> interval_amount;
	}

	left_borders = new int[interval_amount];
	std::cout << "Enter left borders" << std::endl;
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

	std::cout << "Generated numbers: ";
	file << "Generated numbers: ";
	for (int i = 0; i < NumRanDat; i++) {
		std::cout << arr[i] << ' ';
		file << arr[i] << ' ';
	}
	std::cout << '\n';
	file << '\n';

	result_array = new int[interval_amount];
	for (int i = 0; i < interval_amount; i++)
		result_array[i] = 0;

	FUNC(arr, NumRanDat, left_borders, interval_amount, result_array);

	std::cout << "Interval index \tInterval left border \tAmount of numbers in interval" << '\n';
	file << "Interval index \tInterval left border \tAmount of numbers in interval" << '\n';

	for (int i = 0; i < interval_amount; i++)
	{
		std::cout << "\t" << i + 1 << "\t\t" << left_borders[i] << "\t\t\t" << result_array[i] << '\n';
		file << "\t" << i + 1 << "\t\t" << left_borders[i] << "\t\t\t" << result_array[i] << '\n';
	}

	delete[] left_borders;
	delete[] arr;
	delete[] result_array;
	file.close();
	return 0;
}