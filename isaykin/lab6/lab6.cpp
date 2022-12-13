#include <iostream>
#include <fstream>
#include <random>
using namespace std;
std::ofstream file("out.txt");
extern "C" {void function1(int* array, int arr_len, int* answer, int mi, int v); }
extern "C" {void function2(int* array, int arr_len, int* l_borders, int bord_len, int mi, int* answer); }
void sort(int*arr, int count_) {
	for (int i = 0; i < count_ - 1; i++) {
		for (int j = 0; j < count_ - i - 1; j++) {
			if (arr[j] > arr[j + 1]) {
				int buf = arr[j];
				arr[j] = arr[j + 1];
				arr[j + 1] = buf;
			}
		}
	}
}
int main() {
	int length;
	do{
		cout << "Length\n";
		cin >> length; 
	}
    while((length > 16384) || (length <= 0));
	int mi, ma;
	do{
		cout << "min\n";
		cin >> mi;
		cout << "max\n";
		cin >> ma;
	}
    while(mi > ma);
	int  *arr = new int[length];
    std::mt19937 r;
    std::random_device device;
    r.seed(device());
	for(int i = 0; i < length; i++){
		arr[i] = mi + r() % (ma - mi + 1);
		cout << arr[i] << ' ';
	}
	cout << endl;
	int count;
	do{
		cout << "count\n";
		cin >> count;
	}
    while((count > 24) || (count < 1) || (count >(ma - mi + 1)));
	int *l_borders = new int[count];
	for(int i = 0; i < count; i++){
		do{
			cout << i <<"\n";
			cin >> l_borders[i];
		}
        while((l_borders[i] < mi) || (l_borders[i] > ma));
	}
	sort(l_borders, count);
	int* buf_result = new int[ma - mi + 1] {0};
	function1(arr, length, buf_result, mi, 0);
	for (int i = 0; i < ma - mi + 1; i++) {
		cout << buf_result[i] << ' ';
	}
	cout << endl;
	int* final_result = new int[count] {0};
	function2(buf_result, ma - mi + 1, l_borders, count, mi, final_result);
    for(int i = 0; i < count; i++){
        file<<'('<<l_borders[i]<<") = "<<final_result[i]<<"; ";
    }
	delete[] arr;
	delete[] l_borders;
	delete[] buf_result;
	delete[] final_result;
	file.close();
	return 0;
}