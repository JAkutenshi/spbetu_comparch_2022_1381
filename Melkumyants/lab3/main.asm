dosseg
.model small
.stack 100h
.data
i  dw -1
a dw -5
b dw -6
k dw 1
res dw ?
.code
mov ax, @data
mov ds, ax

mov ax, a
cmp ax, b
jg second

first: ;if(a<=b)
mov cx, i ;i
add cx, i ;2i
add cx, i ; 3i
sal cx, 1 ; 6i
neg cx  ; -6i
add cx, 6 ;-(6i-6)

mov ax, cx ; -(6i-6)
add ax, 2 ; -6i+8
jmp final

second: ;if(a>b)
mov ax, i ; i
mov cl, 2
sal ax, cl ; 4i
neg ax    ; -4i
add ax, 7 ; -4i+7

mov cx, ax ; -4i+7
add cx, 13 ; -4i+20

final:
abs_1:
cmp k, 0
jnz abs_0
add ax, cx
neg ax
js abs_1
jmp ex


abs_0:
cmp cx, ax
jl mnr 
jmp ex
mnr: mov ax, cx
ex: mov res, ax
mov ah, 4ch
int 21h
end
