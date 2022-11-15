SOUND_FREQ EQU 5000d

STACK SEGMENT STACK
    DW 512 DUP(?)
STACK ENDS

DATA SEGMENT
    KEEP_CS DW 0
    KEEP_IP DW 0
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:STACK
    MY_SUBR_INT PROC FAR
        push ax
        push cx

        mov al, 20h
        out 20h, al

        in al, 61h
        or al, 11b
        out 61h, al

        mov bx, SOUND_FREQ
    loop_:
        mov ax, bx
        out 42h, al
        mov al, ah
        out 42h, al

        mov ah, 0h
		int 16h
		cmp al, '+'
		je high_
		cmp al, '-'
		je low_
        cmp al, 27
		je exit
        jmp loop_
    high_:
        cmp bx, 10000
        jge loop_
        add bx, 1000
        jmp loop_
    low_:
        cmp bx, 1000
		jle loop_
		sub bx, 1000
		jmp loop_

    exit:
        in  al, 61h
    	xor al, 11b
    	out 61h, al

        pop cx
        pop ax
        iret
    MY_SUBR_INT ENDP

    MAIN PROC FAR
        push DS
        sub AX, AX
        push AX
        mov AX, DATA
        mov DS, AX

        mov AX, 3560h
		int 21h

        mov KEEP_CS, es ; save regs
        mov KEEP_IP, bx

        push ds    ; custom interruption setting
        mov dx, offset MY_SUBR_INT
        mov ax, seg MY_SUBR_INT
        mov ds, ax
        mov ax, 2560h
        int 21h
        pop ds

        int 60h

        CLI   ; previous interruption restoring
        push ds
        mov dx, KEEP_IP
        mov ax, KEEP_CS
        mov ds, ax
        mov ax, 2560h
        int 21h
        pop	DS
        STI

        mov AH, 4ch
        int 21h
    MAIN ENDP
CODE ENDS
END MAIN