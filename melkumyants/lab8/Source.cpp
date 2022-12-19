#include <iostream>
#include <fstream>
#include <random>


double POLY(double x, int n, double* con){
	double y;

	_asm {
		fld x;
		mov esi, con
		mov edi, n
		fldz
		test edi, edi

			jz c_end
		mov ecx, edi
		horner:
			fmul st, st(1)
			fadd qword ptr[ecx * 8 + esi - 8]
			loop horner
		c_end :
			fstp y;
	}
	return y;
}



int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");
	
	double x;
	std::cout << "¬ведите х: ";
	std::cin >> x;

	int n;
	std::cout << "¬ведите количетсво констант: ";
	std::cin >> n;

	double* con = new double[n];
	double s;

	std::cout << "¬ведите константы: ";
	for (int i = 0; i < n; i++) {
		std::cin >> con[i];
	}
	//double res = POLY(x, n, con);
	double res = POLY(x, n, con);

	std::cout << "–езультат: " << res;

	delete[] con;

}
