#include <math.h>
#include <iostream>

long double x,result;
long double two = 2;
long double e = exp(1);

long double cosH(long double result1) {
	__asm {

		; Возведение e^x
		fld x				//загрузка переменных в стек st
		fld e
		fyl2x				//ST(1) = ST(1) * log2(ST(0))
		fld st				//Загрузить ST(0) в регистровый стек
		frndint				//Округлить ST(0) к целому
		fsub st(1), st		//ST(1) = ST(1) - ST(0)
		fxch st(1)			//Обмен значений ST(0) и ST(1)
		f2xm1				//ST(0) = 2^ST(0) - 1
		fld1				//Загрузить +1.0 в регистровый стек
		faddp st(1), st		//ST(1) = ST(0) + ST(1)
		fscale				//ST(0) = ST(0) * 2^ST(1)
		fstp st(1)			//Сохранить ST(0) в ST(1)
		fst result1

		; Деление 1 / e^x
		fld1				//Загрузить +1.0 в регистровый стек
		fdiv result1

		fadd st, st(1)		//Получение e^x + 1 / (e^x)
		fdiv two			//Получение cosh(x)
		fstp result1			//ответ
	}

	return result1;
}

int main() {
	system("chcp 1251 > nul");
	setlocale(LC_CTYPE, "rus");

	std::cout << "Вычисление cosh(x). Введите значение х:\n";
	std::cin >> x;

	result = cosH(result);

	printf("Вычисленное значение cosh(x): %lf\n", result);
	return 0;
}