.586p
.MODEL FLAT, C
.CODE
function2 PROC C USES EDI ESI, array:dword, arr_len:dword, l_borders:dword, bord_len:dword, mi:dword, answer:dword
push eax
push ebx
push ecx
push edx
push edi
push esi
mov ecx, arr_len
mov ebx, bord_len
dec ebx
mov eax, arr_len
add eax, mi
dec eax
mov esi, array
mov edi, l_borders
mov edx, 0
f:
    cmp eax, [edi+ebx*4]
    jl ff
    dec ecx
    add edx, [esi+ecx*4]
    inc ecx
    dec eax
loop f
ff:
    mov edi, answer
    mov [edi+ebx*4], edx
    mov edx, 0
    mov edi, l_borders
    dec ebx
    cmp ecx, 0
jnz f
pop esi
pop edi
pop edx
pop ecx
pop ebx
pop eax
ret
function2 ENDP
END