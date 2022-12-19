#include <stdio.h>
#define SIZE 81

int main(){

printf("Mantseva Tatyana, group 1381. From hexadecimal to binary numbers\n");

char input[SIZE];
char result[SIZE*4];
int zeros = 0;

fgets(input,SIZE,stdin);

asm (  "check:             \n"
       "\t lodsb           \n"
       "\t cmp %%al,0      \n"
       "\t je exit         \n"
       "\t cmp %%al,'0'    \n"
       "\t jl write        \n"
       "\t cmp %%al,'F'    \n"
       "\t jg write        \n"
       "\t cmp %%al,'9'    \n"
       "\t jle number      \n"
       "\t cmp %%al,'A'    \n"
       "\t jge letter      \n"
         
       "\t number:         \n"
       "\t sub %%al,48     \n"
       "\t jmp binary      \n"
         
       "\t letter:         \n"
       "\t sub %%al,55     \n"
         
       "\t binary:         \n"
       "\t mov %%bl,%%al   \n"
       "\t add %1,4        \n"
       "\t cmp %%bl, 8     \n"
       "\t mov %%al,'0'    \n"
       "\t jl fourth       \n"        
       "\t mov %%al,'1'    \n"
       "\t sub %%bl, 8     \n"
       "\t sub %1,1        \n"
         
       "\t fourth:         \n"
       "\t stosb           \n"
       "\t cmp %%bl,4      \n"
       "\t mov %%al,'0'    \n"
       "\t jl third        \n"        
       "\t mov %%al,'1'    \n"
       "\t sub %%bl, 4     \n"
       "\t sub %1,1        \n"
        
       "\t third:          \n"
       "\t stosb           \n"
       "\t cmp %%bl,2      \n"
       "\t mov %%al,'0'    \n"
       "\t jl second       \n"        
       "\t mov %%al,'1'    \n"
       "\t sub %%bl, 2     \n"
       "\t sub %1,1        \n"
       
       "\t second:         \n"
       "\t stosb           \n"
       "\t cmp %%bl,1      \n"
       "\t mov %%al,'0'    \n"
       "\t jl first        \n"        
       "\t mov %%al,'1'    \n"
       "\t sub %%bl, 1     \n"
       "\t sub %1,1        \n"
       
       "\t first:          \n"
       "\t stosb           \n"
       "\t jmp end         \n"
       "\t write:          \n"
       "\t stosb           \n"
       "\t end:            \n"
	   "\t jmp check       \n"
	   "\t exit:           \n"
	   : "=m" (result),
	     "=m" (zeros)                      
	   : "S"  (input),
		 "D"  (result)              
	);
	
printf("result = %s", result);
printf("zeros = %d\n", zeros);
return 0;
}
