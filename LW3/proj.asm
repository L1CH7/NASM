%include "./lib64.asm"

section .data
    StartMsg    db "Enter (a, b, x): ", 10
    StartLen    equ $-StartMsg
    ExitMsg     db "Result: ", 10
    ExitLen     equ $-ExitMsg

section .bss
    a       resq 10
    b       resq 10
    x       resq 10
    f       resq 10
    InBuf   resb 10
    LenIn   equ $-InBuf
    OutBuf  resb 4
    LenOut  equ $-OutBuf

section .text
    global  _start
_start:     mov     rax,1
            mov     rdi,1
            mov     rsi,StartMsg
            mov     rdx,StartLen
            syscall ; write
            mov     rax,0
            mov     rdi,0
            mov     rsi,InBuf
            mov     rdx,LenIn
            syscall ; read a
            mov     rdi,InBuf
            call    StrToInt64
            cmp     rbx,0
            jne     0
            mov     [a],rax
            mov     rax,0
            mov     rdi,0
            mov     rsi,InBuf
            mov     rdx,LenIn
            syscall ; read b
            mov     rdi,InBuf
            call    StrToInt64
            cmp     rbx,0
            jne     0   
            mov     [b],rax
            mov     rax,0
            mov     rdi,0
            mov     rsi,InBuf
            mov     rdx,LenIn
            syscall ; read x
            mov     rdi,InBuf
            call    StrToInt64
            cmp     rbx,0
            jne     0
            mov     [x],rax
            ; calculate
            mov     eax,[a]
            imul    dword [x]
            mov     ebx,eax ; rbx=a*x
            mov     ecx,2
            cdq ; eax->rax
            idiv    ecx ; eax=rax/2 = a*x/2; edx = a*x mod 2
            cmp     edx,0
            jnz     Else
            mov     [f],rax ; if rdx=0 ; f = a*x/2
            jmp     Com
    Else:   mov     eax,[b] ; if rdx!=0
            imul    dword [b]
            imul    dword [b] ; rax=b^3
            sub     rbx,rax
            mov     [f],rbx ; f = a*x-b^3
    Com:    mov     rax,1
            mov     rdi,1
            mov     rsi,ExitMsg
            mov     rdx,ExitLen
            syscall ; print msg
            mov     rsi,OutBuf
            mov     rax,[f]
            call    IntToStr64
            mov     rax,1
            mov     rdi,1
            mov     rsi,OutBuf
            mov     rdx,LenOut
            syscall ; print res
    Exit:   mov     rax,60
            xor     rdi,rdi
            syscall
