DOSSEG
.MODEL SMALL
.STACK 100H

.DATA

    a db 5
    b db 3
    i db 10
    k db 0

    i1 db ?
    i2 db ?
    res db ?

.CODE
	mov ax, @data
	mov ds, ax
	mov al, a
	cmp al, b
	jle another
	
	
	
;f6_1 (2*(i+1)-4)
	mov bl, i
	add bl, 1
	mov ax, 2
	mul bl
	sub al, 4
	mov i1, al
	
;f8_1 (-(6*i+8))
	mov bl, i
	mov ax, 6
	mul bl
	add al, 8
	neg al
	mov i2, al
	
	cmp k, 0
	jmp f1_1
	
	another:
;f6_2 (5-3*(i+1))
	mov bl, i
	add bl, 1
	mov ax, 3
	mul bl
	neg al
	add al, 5
	mov i1, al
;f8_2 (9-3*(i-1))
	mov bl, i
	sub bl, 1
	mov ax, 3
	mul bl
	neg al
	add al, 9
	mov i2, al

	jmp f1_1
	
	f1_1:
;min(i1, i2)
	mov al, i1
	mov bl, i2
	mov cl, k
	cmp k, 0
	jne f1_2
	cmp al, bl
	jl min
	je equal
	mov dl, i2
	jmp ending

	f1_2:
;max(i1, i2)
	
	mov al, i1
	mov bl, i2
	cmp bl, al
	jg max
	je equal
	mov dl, i1
	jmp ending
	
	min:
	mov dl, i1
	mov res, dl
	jmp ending
	
	equal:
	mov dl, i1
	mov res, dl
	jmp ending

	max:
	mov dl, i2
	mov res, dl
	jmp ending
	
	
	ending:
	mov ah, 4ch
	int 21h


END
	