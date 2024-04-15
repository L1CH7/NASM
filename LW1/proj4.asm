section .data
    A dw 25
    B dd -35
    ename db "Pahom", 10
    rname db "Пахом", 10
section .text
    global _start
_start:
    mov ebx, 228
    syscall