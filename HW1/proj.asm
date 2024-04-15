%include "../lib64.asm"

section .data
    NewLine     db 0xA
    StartMsg    db 0xA,"Enter a string with less than 35 symbols:",0xA
    StartLen    equ $-StartMsg
    ExitMsg     db "Exit...",0xA
    ExitLen     equ $-ExitMsg
    ResultMsg   db "Result: ",0x0
    ResultLen   equ $-ResultMsg

section .bss
    OutBuf      resb 35
    LenOut      equ $-OutBuf
    InBuf       resb 36                 ; 35+1=36 because EndOfString symbol
    LenIn       equ $-InBuf

section .text
    global _start
_start:         call    PrintStart
                call    ReadString
                call    PrintResult
                call    Calculate       ; get InBuf, return rax
                call    PrintOutput     ; prints number in rax
                call    PrintEnter
                call    PrintExit
    EXIT:       mov     rax,0x3C
                xor     rdi,rdi
                syscall

Calculate:      mov     rsi,InBuf       ; pointer to symbol
                xor     rbx,rbx         ; count of symbols in word
                xor     rax,rax         ; count of words
        CYCLE1: cmp     byte[rsi],0xA
                je      IF1             ; if EndOfString(0xA) then last iteration
                cmp     byte[rsi],0x20 ; 0x20=" "
                jne     ELSE1           ; in not Space then reset counter
        IF1:    cmp     rbx,3           ; if Space then compare counter 
                jle     COM1
                inc     rax             ; increment word counter if symbol counter greater than 3
        COM1:   xor     rbx,rbx         ; Space mean end of word => reset rbx to zero
                jmp     NEXT1
        ELSE1:  inc     rbx             ; if not Space then increase symbol counter
        NEXT1:  inc     rsi             ; get next symbol
                cmp     byte[rsi-1],0xA ; if EndOfString then exit ; rsi-1 `cuz it`ve been incremented before
                jne     CYCLE1
                ret ; answer is in rax

            ; gets number from eax
PrintOutput:    mov     rsi,OutBuf
                call    IntToStr64
                mov     eax, 1
                mov     edi, 1
                mov     rsi, OutBuf
                mov     rdx, LenOut
                syscall
                ret

        ; reads string from stdin ; puts 0xA at the end    
ReadString:     mov     rax,0
                mov     rdi,0
                mov     rsi,InBuf
                mov     rdx,LenIn
                syscall
                ret

PrintEnter:     mov     rax,1
                mov     rdi,1
                mov     rsi,NewLine
                mov     rdx,1
                syscall
                ret

PrintStart:     mov     rax,1
                mov     rdi,1
                mov     rsi,StartMsg
                mov     rdx,StartLen
                syscall
                ret

PrintResult:    mov     rax,1
                mov     rdi,1
                mov     rsi,ResultMsg
                mov     rdx,ResultLen
                syscall
                ret

PrintExit:      mov     rax,1
                mov     rdi,1
                mov     rsi,ExitMsg
                mov     rdx,ExitLen
                syscall
                ret
                