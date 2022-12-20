.586p
.MODEL FLAT, C
.CODE
function1 PROC C USES EDI ESI, array:dword, arr_len:dword, answer:dword, mi:dword, v:dword

push eax
push ebx
push edx
push esi
push edi
mov eax, 0
mov ebx, 0
mov esi, array
mov edi, answer
count:
    cmp ebx, arr_len
    jge out1
    mov eax, [esi+ebx*4]
    mov v, eax
    sub eax, mi
    mov edx, [edi+eax*4]
    inc edx
    mov [edi+eax*4], edx
    add ebx, 1
    jmp count
out1:
    pop edi
    pop esi
    pop edx
    pop ebx
    pop eax
    ret
function1 ENDP
END