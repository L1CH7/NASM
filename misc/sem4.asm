%include "../lib64.asm"
; EA = base + index*scale + displacement
; LEA ebx, [esi*4+Table]
; ebx = addr of (esi*4+table)

section .data
    ; arrays
    MAS dw 0,1,2,3,4,5,6,7,8,9
    N dw 3 ; elem number 3
    ; matrix
    A dq -1,  -1, -1, 0, 0
      dq -10, -10, 0, 0, 0
      dq -10,  -10, -10, 0, 0
    ; A  dq 0,1,2,3,4
    ;    dq 5,6,7,8,9
    ;    dq 10,11,12,13,14

section .bss
    ans resw 1
    InBuf resb 10
    LenIn equ $-InBuf

    OutBuf resb 4
    LenOut equ $-OutBuf

section .text
    global _start

    _start: 
            jmp COLUMNS2
            ; ARRAY
            ; пусть существует МАС 10 эл-тов. Найти их сумму

    ARR_SUM: ; 1) смещение текущего элемента отн-но начала сегмента
            xor  AX,AX ; обнулим аккумулятор
            lea  EBX,[MAS]
            mov  ECX,10
    Cycle1: add  AX,[EBX] ; считаем сумму очередного элемента
            add  EBX,2 ; прибавляем 2 байта
            loop Cycle1

            call OUTPUT
            jmp EXIT



    ARR_MAX:; 2) считаем смещение текущ эл-та отн-но начала массива
            xor  AX,AX
            mov  EBX,0 ; индекс текущего эл-та
            mov  ECX,10
    Cycle2: add  AX,[EBX*2+MAS] ; scale = 2 bytes
            inc  EBX ; increment index
            loop Cycle2

            call OUTPUT
            jmp EXIT

            ; 3) элемент по номеру
            ; a[k] = a.begin + (k-1)*scale(a[i])
            mov  EBX,[N]
            dec  EBX
            mov  AX,[EBX*2+MAS]  ; AX = MAS[N]

            call OUTPUT
            jmp EXIT




    MATRIX_MAX:
            ; MATRIX : A(3x5)
            ; 4) get A.max
            mov  EBX,1 ; начинаем со второго элемента
            mov  ECX,14
            mov  AX,[A] ; AX = A[0,0] = A[0]; A[m,n] ~ A[k] where k = 3*m + n - развертка матрицы
    Cycle3: cmp  AX,[EBX*2+A] ; '+2'
            ; cmp  AX,[EBX*2+2+A] ; '+2' тк нулевой элемент не сравниваем с собой; по той же причине цикл на 15-1=14 повторов
            jge NEXT ; if AX >= A[EBX+1] skip
            mov AX,[EBX*2+A] ; save `cuz it`s greater than AX
    NEXT:   inc EBX
            loop Cycle3

            call OUTPUT




    COLUMNS: ;5) просмотр по столбцам А(3х5)
            ; элементы на одном столбце находятся на расстоянии 5*2=10 байт друг от друга в развертке
            ; элементы в соседних столбцах в одном ряду находятся на расстоянии 2 байта
            ; найти в каждом столбце наименьшее и сложить их между собой
            mov  RCX,5
            mov  RBX,0 ; current column
            mov  RAX,0 ; sum
RowCycle:   push RCX ; move into row
            push RAX ; save auxiliary to store min elem
            mov  RAX,[A+RBX*8] ; RAX = A[0,RBX]
            mov  RCX,2 ; load column cycle 3-1=2
            mov  RSI,40 ; смещение по строкам 5*8=40
    ColCycle:   cmp  RAX,[A+RBX*8+RSI] ; move into column
                jle  NEXT1
                mov  RAX,[A+RBX*8+RSI] ; if less than rax
        NEXT1:  add  RSI,40 ; переход на след строку в столбце
                loop ColCycle
            mov  RDX,RAX ; save RAX in RDX
            pop  RAX ; release RAX
            add  RAX,RDX
            inc  RBX ; go to next column
            pop  RCX
            loop RowCycle

            call OUTPUT
            jmp  EXIT

    COLUMNS2: ; то же, что и COLUMNS, но без push RAX. Так выходит более эффективно
            ;5) просмотр по столбцам А(3х5)
            ; элементы на одном столбце находятся на расстоянии 5*2=10 байт друг от друга в развертке
            ; элементы в соседних столбцах в одном ряду находятся на расстоянии 2 байта
            ; найти в каждом столбце наименьшее и сложить их между собой
            mov  RCX,5
            mov  RBX,0 ; current column
            mov  RAX,0 ; sum
RowCycle2:  push RCX ; move into row
            mov  RDX,[A+RBX*8] ; RDX = A[0,RBX]
            mov  RCX,2 ; load column cycle 3-1=2
            mov  RSI,40 ; смещение по строкам 5*8=40
    ColCycle2:   cmp  RDX,[A+RBX*8+RSI] ; move into column
                 jle  NEXT12
                 mov  RDX,[A+RBX*8+RSI] ; if less than rax
        NEXT12:  add  RSI,40 ; переход на след строку в столбце
                 loop ColCycle2
            add  RAX,RDX
            inc  RBX ; go to next column
            pop  RCX
            loop RowCycle2

            call OUTPUT
            jmp  EXIT

    EXIT:   mov  AX,60
            xor  DI,DI
            syscall

            ;out
    OUTPUT: mov  rsi,OutBuf
            call IntToStr64 ; number must be in AX

            mov  rax,1
            mov  rdi,1
            mov  rsi,OutBuf
            mov  rdx,LenOut
            syscall
            ret