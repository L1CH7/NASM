section .data
    F1 dw 65535
    F2 dd 65535
section .text
    global _start
_start:
    add [F1], word 1
    add [F2], dword 1
    syscall
    mov rax, 18h
    syscall