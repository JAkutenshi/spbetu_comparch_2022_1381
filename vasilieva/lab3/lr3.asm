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
mov cx, cx ;3i+4
add cx, 2  ;3*(i+2) = 3i+6

mov ax, i ;i
add ax, i ;2i
add ax, i ;3i
add ax, 4 ;3i+4
jmp final

f12_else:    ;if(a>b)
mov cx, cx ;15-2i
sub cx, i  ;15-3i
sal cx, 1  ;30-6i
sub cx, 26 ;-(6i-4) = -6i+4

mov ax, 15  ;15
sub ax, i  ;15-i
sub ax, i  ;15-2i
  

final:
abs_that:
cmp k,0
jnz abs_else
add ax, cx
neg ax
js abs_that
jmp results

abs_else:
cmp cx, ax
jl min
jmp results
min: mov ax, cx

results: 
mov res, ax
mov ah, 4ch
int 21h
end
