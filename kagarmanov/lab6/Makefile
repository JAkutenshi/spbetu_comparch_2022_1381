all: main.o module.o 
	gcc main.o module.o -masm=intel -Wall 
main.o: main.c 
	gcc main.c -c 
module.o: module.s
	as -msyntax=intel -mnaked-reg -mmnemonic=intel --gstabs module.s -o module.o
clear:
	rm *.o
run:
	./a.out
