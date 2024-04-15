section .data
    A dd -30
    B dd 21
section .bss
    X resd 1
section .text
    global _start
_start:
    mov rax, [A] ; загрузить число A в регистр rax
    add rax, 5
    sub rax, [B] ; вычесть число B, результат в rax
    mov [X], rax ; сохранить результат в памяти
    syscall

    mov rbx, 228
    syscall