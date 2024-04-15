%include "../lib64.asm"

; определить сумму отриц элементов каждой строки и поместить на место первого элемента(строки)

section .data
    Space db 0x20
    NewLine db 0xA

    StartMsg db "Enter 4*6=24 numbers: ", 0xA
    StartLen equ $-StartMsg

    NLMsg db "Enter new line of matrix: ", 0xA
    NLLen equ $-NLMsg

    InputMsg db "Entered matrix: ", 0xA
    InputLen equ $-InputMsg

    ResultMsg db "Result matrix: ", 0xA
    ResultLen equ $-ResultMsg

    ExitMsg db "Exit program...", 0xA
    ExitLen equ $-ExitMsg

    ColCount dq 4 ; Column Count equals to Line length
    RowCount dq 6 ; Rows(aka Line,String) Count equals to Column length

    ; ColCount dq 2 ; Column Count equals to Line length
    ; RowCount dq 3 ; Rows(aka Line,String) Count equals to Column length
    ; matrix  dq  1,  2
    ;         dq  3,  4
    ;         dq  5,  6

section .bss
    matrix resq 24
    LineByteLen resq 1

    InBuf resb 6
    LenIn equ $-InBuf

    OutBuf resb 8
    LenOut equ $-OutBuf

section .text
    global _start

_start:         call PrintStart
                mov  eax,[ColCount]
                mov  ebx,8 ; sizeof(qword)=8
                mul  ebx
                mov  [LineByteLen],rax ; LineByteLen = ColCount*8
                call ReadMatrix
                call PrintInput
                call PrintMatrix
                call Calculate
                call PrintResult
                call PrintMatrix
                call PrintExit
        EXIT:   mov  rax,60
                xor  rdi,rdi
                syscall

; ---------------------------- end of section ---------------------------- ;

    Calculate:      xor  rsi,rsi ; rsi=0 - current line pointer
                    mov  rcx,[RowCount] ; load outer column loop
            ColCalcLoop:push rcx ; save iterator in stack
                        xor  rbx,rbx ; disp in line
                        xor  eax,eax ; eax=0 - sum of negative elements in a line
                        mov  rcx,[ColCount] ; load inner line loop
            StringCalcLoop: push rcx
                            mov  edx,[rsi+rbx*8+matrix] ; edx = matrix[rsi,rbx]
                            cmp   edx, 0
                            jge  NEXT
                            add  eax,edx ; eax += edx if edx < 0
                    NEXT:   inc  rbx ; get next elem of line
                            pop  rcx
                            loop StringCalcLoop
                        mov  [rsi+matrix],eax
                        add  rsi,[LineByteLen]
                        pop  rcx ; get outer iterator
                        loop ColCalcLoop
                    ret

    ReadMatrix:     xor  rbx,rbx  ; rbx=0
                    mov  rcx,[RowCount] ; load outer column loop
            ColReadLoop:push rcx ; save iterator in stack
                        call PrintNLMsg
                        mov  rcx,[ColCount] ; load inner line loop
            StringReadLoop: push rcx
                            push rbx
                            call ReadSymbol
                            mov  rdi,InBuf
                            call StrToInt64 ; convert string in rdi into integer in rax
                            cmp  rbx,0 ; if 1 then error
                            jne  0
                            pop rbx
                            mov  [rbx*8+matrix],rax ; matrix[rbx] = rax ; sizeof(dword)=4
                            inc  rbx
                            pop  rcx
                            loop StringReadLoop
                        pop  rcx ; get outer iterator
                        loop ColReadLoop
                    ret

    ReadSymbol:     mov  rax,0
                    mov  rdi,0
                    mov  rsi,InBuf
                    mov  rdx,LenIn
                    syscall
                    ret

    PrintMatrix:    xor  rbx,rbx ; rbx=0
                    mov  rcx,[RowCount]
       ColPrintLoop:push rcx
                    mov  rcx,[ColCount]
        StringPrintLoop:push rcx ; save rcx
                        mov  eax, [rbx*8+matrix] ; get matrix[rbx] ; rbx*8 `cuz elem is qword
                        push rbx ; save rbx
                        call PrintNumber
                        call PrintSpace
                        pop  rbx ; get rbx
                        inc  rbx ; rbx+=1
                        pop  rcx ; get rcx
                        loop StringPrintLoop
                    call PrintNewLine
                    pop  rcx
                    loop ColPrintLoop
                ret

    PrintSpace:     mov  rax, 1
                    mov  rdi, 1
                    mov  rsi, Space
                    mov  rdx, 1
                    syscall
                    ret

    PrintNewLine:   mov  rax, 1
                    mov  rdi, 1
                    mov  rsi, NewLine
                    mov  rdx, 1
                    syscall
                    ret

                ; gets number from eax
    PrintNumber:    mov  rsi,OutBuf
                    call IntToStr64
                    mov  eax, 1
                    mov  edi, 1
                    mov  rsi, OutBuf
                    mov  rdx, LenOut
                    syscall
                    mov qword[OutBuf],0 ; clean buffer out of b******t
                    ret

    PrintStart:     mov  rax,1
                    mov  rdi,1
                    mov  rsi,StartMsg
                    mov  rdx,StartLen
                    syscall
                    ret

    PrintInput:     mov  rax,1
                    mov  rdi,1
                    mov  rsi,InputMsg
                    mov  rdx,InputLen
                    syscall
                    ret
                
    PrintResult:    mov  rax,1
                    mov  rdi,1
                    mov  rsi,ResultMsg
                    mov  rdx,ResultLen
                    syscall
                    ret

    PrintExit:      mov  rax,1
                    mov  rdi,1
                    mov  rsi,ExitMsg
                    mov  rdx,ExitLen
                    syscall
                    ret

    PrintNLMsg:     push rdx
                    mov  rax,1
                    mov  rdi,1
                    mov  rsi,NLMsg
                    mov  rdx,NLLen
                    syscall
                    pop  rdx
                    ret
