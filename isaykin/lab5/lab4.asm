STACK SEGMENT STACK
    DW 512 DUP(0)
STACK ENDS

DATA SEGMENT
    KEEP_CS DW 0
    KEEP_IP DW 0
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:STACK
    SUBR_INT PROC FAR
        push ax
        push cx

        sub cx, cx

        in al, 61h
        mov ah, al
        and al, 0FEh
        sound:
        or al, 2
        out 61h, al
        and al, 0FDh
        out 61h, al
        loop sound
        mov al, ah
        out 61h, al
        
        pop cx
        pop ax

        mov al, 20h
        out 20h, al
        iret
    SUBR_INT ENDP

    MAIN PROC FAR
        push DS
        sub AX, AX
        push AX
        mov AX, DATA
        mov DS, AX

        mov AX, 3523h
        int 21h
        mov KEEP_CS, es
        mov KEEP_IP, bx
        
        push ds
        mov dx, offset SUBR_INT
        mov ax, seg SUBR_INT
        mov ds, ax
        mov ax, 2523h
        int 21h
        pop ds

        int 23h

        CLI
        mov dx, KEEP_IP
        mov ax, KEEP_CS
        mov ds, ax
        mov ax, 2523h
        int 21h
        pop ds
        STI

        mov AH, 4ch
        int 21h
    MAIN ENDP

CODE ENDS

END MAIN