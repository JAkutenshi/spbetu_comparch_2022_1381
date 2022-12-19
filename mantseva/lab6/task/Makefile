all: lab6t.o lb6t.o
	gcc -g3 lab6t.o lb6t.o -Wall -masm=intel
lab6t.o: lab6t.c
	gcc -c lab6t.c
lb6t.o: lb6t.s
	as lb6t.s -msyntax=intel -mnaked-reg -mmnemonic=intel --gstabs -o lb6t.o	
