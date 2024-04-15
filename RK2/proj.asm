section .bss
    EOL resb 1 ; end of line
    FLAG resb 1 ; true if correct symbol
    InBuf resb 60
    LenIn equ $-InBuf

section .data
    NLSymbol db 0xA
    Symbols db 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789#?@' ; array of acceptable symbols
    LenSym equ $-Symbols

section .text
    global _start

_start:         mov  rax,0
                mov  rdi,0
                mov  rsi,InBuf
                mov  rdx,LenIn
                syscall ; readln
                mov  [FLAG],byte 1
                mov  [EOL],byte 0
                mov  rbx,rsi
                mov  r8,0 ; r8 stores word length
    Cycle:      cmp  byte[rsi],0xA
                jne  NotNL
                mov  [EOL],byte 1
    NotNL:      cmp  byte[rsi],0x20 ; char=' ' or char=0xA
                je   IfSpace
                cmp  [EOL],byte 1  ; if not ' ' or 0xA then leave if
                jne  NotSpace
    IfSpace:    cmp  [FLAG],byte 0
                je   NotFlag ; if space and flag=false then dont print word
                push rsi ; save rsi in stack
                mov  rax,1
                mov  rdi,1
                mov  rsi,rbx ; addr of word
                mov  rdx,r8  ; length of word
                syscall ; print word addressed at rbx
                call PrintEnter
                pop  rsi ; get rsi from stack
    NotFlag:    cmp  byte[rsi],0xA
                je   Exit ; if EOL => exit
                mov  rbx,rsi
                inc  rbx ; rbx+=rsi+1 ; get ptr to next word
                mov  r8,0 ; reset word length
                mov  [FLAG],byte 1 ; reload FLAG for new word
                jmp  Next ; skip checking for space
    NotSpace:   mov  rcx,LenSym ; load CheckCycle
                cmp  [FLAG],byte 0
                je   Next ; if flag=false then go to next space by skipping letters
    CheckCycle: mov  dl,byte[Symbols+rcx-1]
                cmp  byte[rsi],dl
                je   Found
                loop CheckCycle ; if loop ended => not found
                mov  [FLAG],byte 0 ; false `cuz not found
    Found:      inc  r8 ; len++
    Next:       inc  rsi
                jmp  Cycle
    Exit:       mov  rax,0x3C
                xor  rdi,rdi
                syscall

    PrintEnter: mov  rax,1
                mov  rdi,1
                mov  rsi,NLSymbol
                mov  rdx,1
                syscall
                ret
