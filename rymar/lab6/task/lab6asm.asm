.586p
.MODEL FLAT, C
.CODE
 
PUBLIC C func1      
func1 PROC C USES EDI ESI,\
ArrNumber:DWORD, QuantNumber:DWORD, ArrInter1:DWORD, Xmin:DWORD
 
MOV EDI, ArrNumber                      
MOV ESI, ArrInter1        
MOV ECX, QuantNumber           
MOV EAX, Xmin                                             
 
CYCLE:
    MOV EBX, [EDI]                 
    SUB EBX, EAX                  
    ADD DWORD PTR[ESI+4*EBX], 1;  
    ADD EDI, 4                   
LOOP CYCLE      
 
RET 
func1 ENDP
 
 
 
PUBLIC C func2  
func2 PROC C USES EDI ESI,\                                        
ArrInter1:DWORD, ArrRightBorder:DWORD, ArrInterDif:DWORD, ArrAverage:DWORD,\
ArrSum:DWORD, QuantBorder:DWORD, Xmin:DWORD
 
MOV EDI, ArrRightBorder    
MOV ESI, ArrInter1      
MOV ECX, QuantBorder    
MOV EBX, XMIN   
 
 
XOR EDX, EDX
XOR EAX, EAX
 
CYCLE:
    MOV EDI, ArrRightBorder
    CMP EBX, [EDI+EAX*4]           
    JG NEXT_RANGE        
    PUSH EDX
 
    PUSH EAX
    MOV EAX, [ESI]
    MUL EBX
    MOV EDX, EAX
    POP EAX
 
    MOV EDI, ArrSum
    ADD [EDI+EAX*4], EDX
    MOV EDI, ArrInterDif
 
    POP EDX
    ADD EDX, [ESI]       
    INC EBX               
    ADD ESI, 4           
    JMP CYCLE
NEXT_RANGE:               
    MOV EDI, ArrInterDif
    MOV [EDI+EAX*4], EDX        
    XOR EDX, EDX         
    INC EAX
LOOP CYCLE
 
 
MOV ESI, ArrSum
MOV EDI, ArrInterDif
 
XOR EAX, EAX
XOR EBX, EBX
XOR ECX, ECX
 
CYCLE_AVG:
    XOR EDX, EDX
 
    MOV EAX, [ESI+ECX*4]
    MOV EBX, [EDI+ECX*4]
    CMP EBX, 0
    JE LSKIP
    CMP EAX, 0
    JL NUMLESSZERO
    DIV EBX
    JMP WRITE
 
NUMLESSZERO:
    NEG EAX
    DIV EBX
    NEG EAX
 
WRITE:
    MOV EDI, ArrAverage
    MOV [EDI+ECX*4], EAX
    MOV EDI, ArrInterDif
 
LSKIP:
    INC ECX
    CMP ECX, QuantBorder
    JNE CYCLE_AVG

RET
func2 ENDP
END