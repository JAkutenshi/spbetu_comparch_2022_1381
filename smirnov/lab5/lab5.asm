SOUND_FREQ EQU 10000d

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

        mov ax, SOUND_FREQ
        out 42h, al
        mov al, ah
        out 42h, al

        in al, 61h
        or al, 11b
        out 61h, al

        sub cx, cx
    sound:
        loop sound

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