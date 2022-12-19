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
mov dx, i  ; i
shl dx, 1  ; 2i
add dx, i  ; 3i
mov ax, a
cmp ax, b
jg func2

func1:    ; a<=b
	mov cx, dx   ; 3i
	neg cx       ; -3i
	add cx, 12   ; 9-3(i-1)

	mov ax, cx   ; 12-3i
	shl ax, 1    ; 24-6i
	sub ax, 18   ; -(6i-6)
	jmp func3

func2:    ; a>b
	mov cx, dx   ; 3i
	shl cx, 1    ; 6i
	add cx, 8    ; 6i+8
	neg cx       ; -(6i+8)

	mov ax, cx   ; -(6i+8)
	add ax, 28   ; 20-6i
	add ax, i    ; 20-5i
	add ax, i    ; 20-4i
	
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
	jmp result

result: 
	mov res, cx
	mov ah, 4ch
	int 21h
	end
