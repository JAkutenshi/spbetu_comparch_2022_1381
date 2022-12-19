dosseg
.model small
.stack 100h
.data
i dw -1
a dw -5
b dw -5
k dw -6
res dw 0
.code
mov ax, @data
mov ds, ax

mov ax, a
cmp ax, b  ;сравниваем равны ли a и b.
jg second  ;выполняет короткий переход, если первый операнд БОЛЬШЕ второго операнда

first:     ;if(a<=b)
mov cx, i  ;i
add cx, i  ;2i
add cx, i  ;3i
add cx, 4  ;3i+4

mov ax, cx ;3i+4
sub ax, 7  ;3i-3
sal ax, 1  ;6i-6
neg ax     ;-(6i-6)  
jmp final

second:    ;if(a>b)
mov cx, 15 ;15
sub cx, i  ;15 - i
sub cx, i  ;15-2i

mov ax, cx ;15-2i
sub ax, 5  ;10-2i
sal ax, 1  ;20-4i 

final:
f_0:
cmp k, 0   ; сравниваем равны ли k и 0
jge f_1   ;переход, если больше или равно
sub cx, ax
mov ax, cx
getabs_0:  ;модуль
neg ax
js getabs_0
cmp ax, 2  ;сравниваем 
jl answer  ; ax < 2 => переход
mov ax, 2
jmp answer ;безусловный переход


f_1:
getabs_1:  ; отрицательный 
neg ax
jns getabs_1 ; переход, если нет знака

cmp ax, -6
jg answer   ; переходим, если ax > -6
mov ax, -6

answer: 
mov res, ax
mov ah, 4ch
int 21h
end