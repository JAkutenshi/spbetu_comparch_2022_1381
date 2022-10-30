dosseg
.model small
.stack 100h
.data
i dw 1
a dw 6
b dw 5
k dw -1
res dw ?
.code
mov ax, @data
mov ds, ax
mov ax, a
cmp ax, b
jg second
first: ;if(a<=b)
	mov ax, i   ;i
	shl ax, 1   ;2i
	add ax, i   ;3i
	add ax, 4	;3i+4		(1)	
	
	mov cx, ax  ;3i+4
	neg cx		;-3i-4
	shl cx, 1	;-6i-8
	add cx, 14	;-(6i-6)	(2) 
	jmp final

second: ;if(a>b)
	mov ax, i   ;i
	shl ax, 1   ;2i
	neg ax      ;-2i
	add ax, 15  ;-2i+15		(1)
	
	mov cx, ax  ;-2i+15
	shl cx, 1	;-4i+30
	sub cx, 10	;-4i+20		(2)

final:
min:
	neg cx
	cmp k, 0
	jge max		;if(k>=0)
	add cx, ax	;-i2+i1
	abs:
	neg cx 
	js abs      ;|-i2+i1|
	cmp cx, 2
	jge	result_min ;if(|i2 - i1|>=2)
	jmp result
	
max:
	cmp cx, -6
	jle result_max ;if(-i2<=-6)
	jmp result

result_min:
	mov cx, 2
	jmp result

result_max: mov cx, -6
result: 
	mov res, cx
	mov ah, 4ch
	int 21h
	end



