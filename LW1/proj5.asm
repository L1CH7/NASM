section .data
    dw 37
    dw 9472
    dw 25h
    dw 2500h
section .text
    global _start
_start:
    mov rax, 1337
    syscall