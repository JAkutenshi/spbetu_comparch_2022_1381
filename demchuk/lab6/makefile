all: main.o func.o 
	gcc main.o func.o -masm=intel -Wall 
main.o: main.c 
	gcc main.c -c 
func.o: func.s
	as -msyntax=intel -mnaked-reg -mmnemonic=intel --gstabs func.s -o func.o
clear:
	rm *.o
run:
	./a.out