all: lab6.o lb6.o
	gcc -g3 lab6.o lb6.o -Wall -masm=intel
lab6.o: lab6.c
	gcc -c lab6.c
lb6.o: lb6.s
	as lb6.s -msyntax=intel -mnaked-reg -mmnemonic=intel --gstabs -o lb6.o	
