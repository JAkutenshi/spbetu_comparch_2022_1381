.586p
.MODEL FLAT, C
.CODE
function2 PROC C USES EDI ESI, array:dword, arr_len:dword, l_borders:dword, bord_len:dword, mi:dword, amswer_max:dword, answer:dword
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
v:
    cmp eax, [edi+ebx*4]
    jl ff
    dec ecx
    add edx, [esi+ecx*4]
    inc ecx
    cmp edx, 0
    jg av
    dec eax
    loop v
av:
    mov edi, amswer_max
    mov [edi+ebx*4], eax
    mov edi, l_borders
    jmp vv
f:
    cmp eax, [edi+ebx*4]
    jl ff
    dec ecx
    add edx, [esi+ecx*4]
    inc ecx
vv:
    dec eax
loop f
ff:
    mov edi, answer
    mov [edi+ebx*4], edx
    mov edx, 0
    mov edi, l_borders
    dec ebx
    cmp ecx, 0
jnz v
pop esi
pop edi
pop edx
pop ecx
pop ebx
pop eax
ret
function2 ENDP
END