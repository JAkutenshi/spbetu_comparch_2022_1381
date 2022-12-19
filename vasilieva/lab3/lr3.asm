dosseg
.model small
.stack 100h
.data
i dw 1
a dw -5
b dw 8
k dw 4
res dw ?
.code
mov ax, @data
mov ds, ax
mov ax, a
cmp ax, b  ;сравниваем a и b.
jg f12_else  ;выполняет короткий переход, если a больше b

f12_that:    ;if(a<=b) 
mov cx, i ;i
add cx, i ;2i
add cx, i ;3i
add cx, 4 ;3i+4

mov ax, cx ;3i+4
add ax, 2  ;3*(i+2) = 3i+6
jmp final

f12_else:    ;if(a>b)
mov cx, 15  ;15
sub cx, i  ;15-i
sub cx, i  ;15-2i

mov ax, cx ;15-2i
sub ax, i  ;15-3i
sal ax, 1  ;30-6i
sub ax, 26 ;-(6i-4) = -6i+4
  
final:
abs_that:
cmp k,0
jnz abs_else ;перейти если не равно
add ax, cx
neg ax
jmp results

abs_else:
cmp cx, ax ;сравниваем i1 и i2
jl min
jmp results

min: mov ax, cx

results: 
mov res, ax
mov ah, 4ch
int 21h
end
