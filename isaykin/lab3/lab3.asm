AStack SEGMENT STACK
    DW 12 DUP(?)
AStack ENDS

DATA SEGMENT
    a DW 0
    b DW 0
    i DW 56
    k DW 0

    i1 DW 0
    i2 DW 7
    res DW 4
DATA ENDS

CODE SEGMENT
    ASSUME CS:CODE, DS:DATA, SS:AStack
    Main PROC FAR
        push ds
        mov ax, 0
        push ax
        mov ax, DATA
        mov ds, ax 
        f1: ;2
        mov ax, i
        sal ax, 1
        mov cx, a
        cmp cx, b
        jle f1_2
        f1_1: ; - (4*i+3)
        sal ax, 1
        mov i1, ax
        add i1, 3
        neg i1
        f2_1: ;7 - 4*i
        sub i2, ax
        jmp f3
        f1_2: ;6*i -10
        add ax, i
        sal ax, 1
        mov i1, ax
        sub i1, 10
        f2_2: ; 8 -6*i
        mov i2, 8
        sub i2, ax
        f3: ;8
        cmp i2, 0
        jge f3_skeep_abs_i2
        neg i2
        f3_skeep_abs_i2:
        cmp k, 0
        jge f3_2
        f3_1: ; |i1| - |i2|
        cmp i1, 0
        jge f3_1_1
        neg i1
        f3_1_1:
        mov ax, i1
        mov res, ax
        mov ax, i2
        sub res, ax
        jmp fend
        f3_2: ;max(4,|i2|-3)
        mov ax, i2
        sub ax, 3
        cmp ax, res
        jl fend
        mov res, ax
        fend:
        ret
    Main ENDP
CODE ENDS
END Main