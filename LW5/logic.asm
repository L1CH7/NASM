    ; src       === RDI
    ; __maxlen  === RAX
    ; __maxc    === RDX
    ; __len     === R8
    ; __c       === R9
    ; disp      === RCX
    ; src + i   === RSI
    ; RDI, RSI, RDX, R10, R8, R9 stores params of function
    ; RDI stores address of string with EOL='\0' 
    ; RDI returns ptr to string
    ; RAX returns some value (in my case)
section .text
    global _Z13max_substringPc
    extern _Z15print_substringPci
_Z13max_substringPc:    push    rbp
                        mov     rbp,rsp         ;установить базу для параметров в стеке
                        xor     rax,rax         ; maxlen=0
                        xor     rdx,rdx         ; maxc=NULL
                        mov     rcx,1           ; disp = 1
        disp_loop:      xor     r8,r8           ; len=0
                        xor     r9,r9           ; c=NULL
                        mov     rsi,rdi
        check_loop:     mov     r10b,[rsi]
                        cmp     r10b,[rsi+rcx]  ; AND gate
                        jne     _ELSE           ; if false => leave
                        cmp     r9,0            ; OR gate begin
                        jz      _IF              ; if true => compute
                        cmp     rsi,r9          ; OR gate end
                        jge     _ELSE           ; if false => leave
                _IF:    cmp     r8,0
                        jnz     _COM1           ; if len not 0
                        mov     r9,rsi          ; char=src+i
                        add     r9,rcx          ; char+=disp
                _COM1:  inc     r8              ; len++
                        cmp     r8,rax
                        jle     _COM2           ; if len <= maxlen => skip
                        mov     rax,r8          ; maxlen=len
                        mov     rdx,r9          ; maxc=c
                _COM2:  jmp     _NEXTcl   
                _ELSE:  xor     r8,r8           ; len=0
                        xor     r9,r9           ; c=NULL
                _NEXTcl:inc     rsi             ; inc src+i
                        cmp     byte[rsi+rcx],0x00 ; (src+i)+disp!='\0'
                        jne     check_loop
                _NEXTdl:inc     rcx             ; inc disp
                        cmp     byte[rdi+rcx],0x00 ; src+disp!='\0'
                        jne     disp_loop
        extern_call:    mov     rdi,rdx         ; rdx->param(rdi)
                        mov     rsi,rax         ; rax->param(rsi)
                        call    _Z15print_substringPci ; print_substring(rdx,rax){/*CXX_CODE*/}
        return:         mov     rsp,rbp         ; удалить область локальных переменных
                        pop     rbp             ; восстановить значение rbp
                        ret
                        