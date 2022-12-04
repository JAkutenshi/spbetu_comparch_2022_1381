DOSSEG
.MODEL SMALL
.STACK 100H

.DATA

    a db 15
    b db 15
    i db 10
    k db 1

    i1 db ?
    i2 db ?
    res db ?

.CODE

	mov ax, @data
	mov ds, ax

	mov bl, i
	mov dl, bl ;dl = i

	shl bl, 1 ;2i
	sub dl, bl ;-i
	sub dl, bl ;-3i
	sub dl, 3 ;-3i-3
	add bl, 2 ;2i+2 
	mov cl, a
	cmp cl, b
	jle another
	
	
;f6_1 (2*(i+1)-4)
	sub bl, 4
	mov i1, bl
	
;f8_1 (-(6*i+8))

	mov al, 6
	mov cl, i
	mul cl
	add al, 8
	neg al
	mov i2, al
	
	cmp k, 0
	jmp f1_1
	
	another:
;f6_2 (5-3*(i+1))

	mov al, dl
	add al, 5
	mov i1, al
;f8_2 (9-3*(i-1))
	
	mov bl, al
	add bl, 10
	mov i2, bl

	jmp f1_1
	
	f1_1:
;min(i1, i2)
	mov cl, i1
	cmp k, 0
	jne f1_2
	cmp cl, i2
	jle min
	mov dl, i2
	jmp ending

	f1_2:
;max(i1, i2)

	cmp cl, i2
	jg max
	mov dl, i2
	jmp ending
	
	min:
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
