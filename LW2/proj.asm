%include "../lib64.asm"

section .data
    StartMsg db "Enter ur numbers here: ", 10
    StartLen equ $-StartMsg
    ExitMsg db "Result: ", 10
    ExitLen equ $-ExitMsg

section .bss
    a resb 10
    b resb 10
    k resb 10
    f resb 10
    InBuf resb 10
    LenIn equ $-InBuf

    OutBuf resb 4
    LenOut equ $-OutBuf

section .text
    global _start
_start:
    ; write
    mov rax,1
    mov rdi,1
    mov rsi,StartMsg
    mov rdx,StartLen
    syscall

    ; read a
    mov rax,0
    mov rdi,0
    mov rsi,InBuf
    mov rdx,LenIn
    syscall

    mov rdi,InBuf
    call StrToInt64
    cmp rbx,0
    jne 0
    mov [a],rax

    ; read b
    mov rax,0
    mov rdi,0
    mov rsi,InBuf
    mov rdx,LenIn
    syscall

    mov rdi,InBuf
    call StrToInt64
    cmp rbx,0
    jne 0
    mov [b],rax

    ; read k
    mov rax,0
    mov rdi,0
    mov rsi,InBuf
    mov rdx,LenIn
    syscall

    mov rdi,InBuf
    call StrToInt64
    cmp rbx,0
    jne 0
    mov [k],rax

    ; calculate
    mov rcx, [k]
    inc rcx ; k+1 in rcx

    mov rax, [a]
    imul rcx
    mov rcx, rax ; a*(k+1) in rcx

    mov rax, [b]
    imul word [b]
    mov rbx, rax ; b^2 in rbx

    mov rax, [a]
    imul word [a] ; a^2 in rax
    sub rax, rbx

    mov rbx, 2
    idiv rbx ; (a^2-b^2)/2 in rax

    add rax, rcx ; f in rax
    mov [f], rax
    
    ; output
    mov rax,1
    mov rdi,1
    mov rsi,ExitMsg
    mov rdx,ExitLen
    syscall

    mov rsi,OutBuf
    mov rax,[f]
    call IntToStr64

    mov rax,1
    mov rdi,1
    mov rsi,OutBuf
    mov rdx,LenOut
    syscall

    ; exit
    mov rax,60
    xor rdi,rdi
    syscall



