;****************************************************************
;                    Shota Nakamura
;                     COMP331: Hw9
;***************************************************************
; Compile like this:
;     nasm -f elf -gstabs ack.asm && ld -o ack -m elf_i386 ack.o
; Run like this:
;     ./ack


; Gives us various IO functions
%include "io.asm"

section .data
message_m: db "Please enter a value for m: "
message_m_len equ $-message_m
message_n: db "Please enter a value for n: "
message_n_len equ $-message_n

result_f1: db "f1 result: "
result_f1_len equ $-result_f1

result_f2: db "f2 result: "
result_f2_len equ $-result_f2


; The text section is for code
section .text
global _start

; function f1
    ;; Leave result in eax
    ;; Don't forget to include the stack frame
f1:
    push ebp
	mov ebp, esp
	
	mov ebx, [ebp+8] ;loads n parameter
	cmp ebx, 1  ;Base case (if n==1)
	je .exp2 ;jumps to exp2
	
	mov ecx, [ebp+12] ;Loads m parameter 
	cmp ecx, 0 ;Base Case (if m==0)
	je .retN ; jumps to retN
;*********************Recursive Call****************************************	
	;We get here if base cases are not met
	;push ebx  ;save n for later
	;push ecx ; save m for later
	dec ecx  ; m-1 (we can (and have to) do this here for this recursive call)
	;we need to run a inner recursive call	where we manipulate the (m,n) values 
	push ecx  ;save m-1 for later (later = pop call)
	push ecx  ;this is for the inner loop
	inc ebx ;increment n by 1 -> n+1 for inner recursive call
	push ebx ;throw n+1 on the stack 
	call f1 ;When we call f1, the bottom two on the stack are removed which is why we push the result(eax) on to the stack
	push eax ;push on to the stack
	jo .overflow
;*********************************************************************
	call f1  ;this is the call for the outer recursive loop 
	jo .overflow
	jmp .retN  ;this will jump to retN
;************************Recursive Call End*************************************************
;**************************If Overflow******************************************************
.overflow:
    mov eax, 0
    jmp .ret_eax
;*******************************************************************************************
.exp2: ;code for exponentiation using left shift
	shl ebx,cl ;this will call left shift m times
	mov eax, ebx
	jmp .ret_eax

.retN:
	mov eax, ebx
	
.ret_eax:
	pop ebp
	ret 8


f2:
    push ebp
	mov ebp, esp
	
	mov ebx, [ebp+8] ;loads n parameter
	cmp ebx, 0  ;Base case (if n==0)
	je .ret1 ;jumps to ret1, setting eax as 1 (eax=ebx+1)
	
	mov ecx, [ebp+12] ;Loads m parameter 
	cmp ecx, 0 ;Base Case (if m==0)
	je .ret1  ;jumps to ret1, setting eax as 1 (eax=ecx+1)
	cmp ecx, 1 ;Base Case (if m==1)
	je .mult2 ;multiply m by 2 and store in eax (eax=2*ecx)
;*********************Recursive Call****************************************	
	;We get here if base cases are not met
	;push ebx  ;save n for later
	;push ecx ; save m for later
	dec ecx  ; m-1 (we can (and have to) do this here for this recursive call)
	;we need to run a inner recursive call	where we manipulate the (m,n) values 
;*****************Inner recursive call********************************
	push ecx  ;save m-1 for later (later = pop call)
	inc ecx ;restores ecx value to m
	push ecx  ;this is for the inner loop
	dec ebx ;decrement n by 1 -> n-1 for inner recursive call
	push ebx ;throw n-1 on the stack 
	call f2  ;inner recursive call 
	push eax ;push on to the stack
	jo .overflow
;*********************************************************************
	call f2  ;this is the call for the outer recursive loop
	jo .overflow
	jmp .retN  ;this will jump to retN
;************************Recursive Call End*************************************************
;**************************If Overflow******************************************************
.overflow:
    mov eax, 0
    jmp .ret_eax
;*******************************************************************************************
.ret1:
	xor eax, eax ;sets eax(return value) to 0
	inc eax ;increments eax by 1 (so eax = 1)
	jmp .ret_eax
.mult2: ;code for exponentiation using left shift
	add ebx,ebx ;multiplying by two is the same thing as adding the value to itself
.retN:
	mov eax, ebx	
.ret_eax:
	pop ebp
	ret 8

; The entrypoint of the program. Test the functions and print the result
_start:


    ; Prompt the user to enter a number for m
    mov eax,4
    mov ebx,1
    mov ecx,message_m
    mov edx,message_m_len
    int 80h
    call read_int
    push eax     ; push value of m


    ; Prompt the user to enter a number for n
    mov eax,4
    mov ebx,1
    mov ecx,message_n
    mov edx,message_n_len
    int 80h
    call read_int
    push eax      ; push value of n

    pop ebx       ; pop value of n
    pop ecx       ; pop value of m

    push ecx      ; set up params for f1 call
    push ebx
    push ecx      ; set up params for f2 call
    push ebx
    ; At this point, the stack contains m,n,m,n
    ; The first m and n will be consumed by f1
    ; The second by f2


    ; Call f1
    call f1
    push eax      ; push the result for print_int
    mov eax,4
    mov ebx,1
    mov ecx,result_f1
    mov edx,result_f1_len
    int 80h
    call print_int ; print_the result
    call print_newline


    ; Call f2
    call f2
    push eax      ; push the result for print_int
    mov eax,4
    mov ebx,1
    mov ecx,result_f2
    mov edx,result_f2_len
    int 80h
    call print_int ;print the result
    call print_newline


; We're done, tell the OS to kill us
    call exit
