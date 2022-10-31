dosseg
.model small
.stack 100h
.data
	a dw 3
	b dw 1
	i dw -1
	k dw 0
	res dw ?

.code
mov ax, @data           
mov ds, ax
mov ax, a
cmp ax, b
jg func2

func1:    ; a<=b
	mov ax, i    ; i
	shl ax, 1    ; 2i
	add ax, i    ; 3i
	mov cx, ax   ; 3i
	shl ax, 1    ; 6i
	sub ax, 6    ; 6i-6
	neg ax       ; -(6i-6)

	neg cx       ; -3i
	add cx, 12   ; 9-3(i-1)
	jmp func3

func2:    ; a>b
	mov ax, i    ; i
	add ax, ax   ; 2i
	add ax, ax   ; 4i
	neg ax       ; -4i
	add ax, 20   ; 20-4i

	mov cx, i    ; i
	shl cx, 1    ; 2i
	add cx, i    ; 3i
	shl cx, 1    ; 6i
	add cx, 8    ; 6i+8
	neg cx       ; -(6i+8)
	
func3:       
	cmp k, 0
	jge max
	sub cx, ax   ; i2-i1

abs:     ; k<0
	neg cx
	js abs       ;|i1-i2|
	jmp result

max:     ; k>=0
	neg cx       ;-i2
	js max       ;|i2|
	cmp cx, 7 
	jge result
	mov cx, 7

result: 
	mov res, cx
	mov ah, 4ch
	int 21h
	end
