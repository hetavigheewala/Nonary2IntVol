Description:	This Program covnerts ASCII nonary to Interger, Calculates Volumes an than Converts the 
;               result into ASCII base10 again. 

; =====================================================================
;  STEP #2
;  Macro to convert ASCII/nonary value into an integer.
;  Reads <string>, convert to integer and place in <integer>
;  Assumes valid data, no error checking is performed.

;  Arguments:
;	%1 -> <string>, register -> string address
;	%2 -> <integer>, register -> result

;  Macro usgae
;	anonary2int  <string-address>, <integer-variable>

;  Example usage:
;	anonary2int	rbx, tmpInteger

;  For example, to get address into a local register:
;		mov	rsi, %1

;  To return a value, it might be:
;		mov	dword [%2], eax

;  Note, the register used for the macro call (rbx in this example)
;  must not be altered BEFORE the address is copied into
;  another register (if desired).

%macro aNonary2int 2

mov eax, 0

; Load each character into ecx
; Compare with space and ignore it when found
; If not space, jump to converting
; Counter loop, go through each character into ECX
; Check if its the end of the String
; if end than jump to ConunterEnd
; Convert ASCII character to numeric
; Multiply by 9
; add the result to current digit
; move pointer to next character
; jmp to next

skip_space_loop:
	movzx ecx, byte[%1]
	cmp ecx, ' '
	jne counterLoop
	inc %1
	jmp skip_space_loop

counterLoop:
	movzx ecx, byte[%1]
	cmp ecx, 0
	je counterEnd
	sub ecx, '0'
	imul eax, eax, 9
	add eax, ecx
	inc %1
	jmp counterLoop
counterEnd:
	mov dword[%2], eax



%endmacro
; =====================================================================
;  Macro to convert integer to nonary value in ASCII format.
;  Reads <integer>, converts to ASCII/nonary string including
;	NULL into <string>

;  Note, the macro is calling using RSI, so the macro itself should
;	 NOT use the RSI register until is saved elsewhere.

;  Arguments:
;	%1 -> <integer-variable>, value
;	%2 -> <string-address>, string address
;	%3 -> <string-length-value>, string length

;  Macro usgae
;	int2aNonary	<integer-variable>, <string-address>, <string-length>

;  Example usage:
;	int2aNonary	dword [volumes+rsi*4], tempString, STR_LENGTH

;  For example, to get the passed value into a local register:
;		mov	eax, %1

%macro int2aNonary 4

; Load first parameter into eax
; Set divisor to 9
; in the Divide loop, divide the first parameter to 9
; push remainder onto Stack
; increment counter
; check if the quotient is zero
; if not then continue next

; popLoop, pop the first value from the stack(remainder)
; convert the remaindr to ASCII
; store the digit 
; next position in the first parameter

    mov     eax, dword %1      
    mov     rcx, 0               
    mov     ebx, 9            
%%divide_Loop:
    mov     edx, 0               
    div     ebx                 
    push    rdx                 
    inc     rcx                   
    cmp     eax, 0            
    jne     %%divide_Loop           
; Convert remainders to ASCII and store in cubeAveString
    mov     rbx, %2
	mov    	rdi, 0

	mov r10, %3
	sub r10, 1
	mov r11, r10
	sub r10, rcx
	add al, " "  
%%space_Loop:
	mov byte[rbx + rdi], al
	inc rdi
	cmp rdi, r10
	jne %%space_Loop

%%pop_Loop:
    pop     rax                   
    add     al, '0'               
    mov     byte [rbx + rdi], al        
    inc     rdi    
	cmp 	rdi, r11               
    jne    %%pop_Loop     

mov byte[rbx + rdi], NULL

%endmacro


; =====================================================================
;  Simple macro to display a string to the console.
;  Count characters (excluding NULL).
;  Display string starting at address <stringAddr>

;  Macro usage:
;	printString  <stringAddr>

;  Arguments:
;	%1 -> <stringAddr>, string address

%macro	printString	1
	push	rax			; save altered registers (cautionary)
	push	rdi
	push	rsi
	push	rdx
	push	rcx

	lea	rdi, [%1]		; get address
	mov	rdx, 0			; character count
%%countLoop:
	cmp	byte [rdi], NULL
	je	%%countLoopDone
	inc	rdi
	inc	rdx
	jmp	%%countLoop
%%countLoopDone:

	mov	rax, SYS_write		; system call for write (SYS_write)
	mov	rdi, STDOUT		; standard output
	lea	rsi, [%1]		; address of the string
	syscall				; call the kernel

	pop	rcx			; restore registers to original values
	pop	rdx
	pop	rsi
	pop	rdi
	pop	rax
%endmacro

; =====================================================================
;  Initialized variables.

section	.data

; -----
;  Define standard constants.

TRUE		equ	1
FALSE		equ	0

EXIT_SUCCESS	equ	0			; successful operation
NOSUCCESS	equ	1			; unsuccessful operation

STDIN		equ	0			; standard input
STDOUT		equ	1			; standard output
STDERR		equ	2			; standard error

SYS_read	equ	0			; system call code for read
SYS_write	equ	1			; system call code for write
SYS_open	equ	2			; system call code for file open
SYS_close	equ	3			; system call code for file close
SYS_fork	equ	57			; system call code for fork
SYS_exit	equ	60			; system call code for terminate
SYS_creat	equ	85			; system call code for file open/create
SYS_time	equ	201			; system call code for get time

LF		equ	10
SPACE		equ	" "
NULL		equ	0
ESC		equ	27

NUMS_PER_LINE	equ	5


; -----
;  Assignment #6 Provided Data

STR_LENGTH	equ	15			; chars in string, with NULL

edgeLengths	db	"            23", NULL, "            37", NULL
		db	"            45", NULL, "            61", NULL
		db	"            55", NULL, "            78", NULL
		db	"           123", NULL, "           137", NULL
		db	"           144", NULL, "           151", NULL
		db	"           180", NULL, "           217", NULL
		db	"           234", NULL, "           240", NULL
		db	"           267", NULL, "           281", NULL
		db	"           302", NULL, "           322", NULL
		db	"           312", NULL, "           327", NULL
		db	"           342", NULL, "           362", NULL
		db	"           372", NULL, "           381", NULL
		db	"           400", NULL, "           411", NULL
		db	"           427", NULL, "           431", NULL
		db	"           445", NULL, "           450", NULL
		db	"           462", NULL, "           477", NULL
		db	"           512", NULL, "           523", NULL
		db	"           532", NULL, "           548", NULL
		db	"           615", NULL, "           627", NULL
		db	"           632", NULL, "           648", NULL
		db	"           652", NULL, "           678", NULL
		db	"           711", NULL, "           728", NULL
		db	"           737", NULL, "           748", NULL
		db	"           777", NULL, "           827", NULL
		db	"           850", NULL, "           888", NULL

aNonaryLength	db	"            55", NULL
length		dd	0

cubeSum		dd	0
cubeAve		dd	0
cubeMin		dd	0
cubeMax		dd	0


; -----
;  Misc. variables for main.

hdr		db	"-----------------------------------------------------"
		db	LF, ESC, "[1m", "CS 218 - Assignment #6", ESC, "[0m", LF
		db	"Cube Calculations", LF, LF
		db	"Cube Volumes:", LF, NULL
shdr		db	LF, "Cube Sum:  ", NULL
avhdr		db	LF, "Cube Ave:  ", NULL
minhdr		db	LF, "Cube Min:  ", NULL
maxhdr		db	LF, "Cube Max:  ", NULL

newLine		db	LF, NULL
spaces		db	"   ", NULL

; =====================================================================
;  Uninitialized variables

section	.bss

tmpInteger	resd	1				; temporary value

volumes		resd	50
edgeLenInts	resd	50

lenString	resb	STR_LENGTH
tempString	resb	STR_LENGTH			; bytes

cubeSumString	resb	STR_LENGTH
cubeAveString	resb	STR_LENGTH
cubeMinString	resb	STR_LENGTH
cubeMaxString	resb	STR_LENGTH


; **************************************************************

section	.text
global	_start
_start:



; -----
;  Display assignment initial headers.

	printString	hdr

;  STEP #1
;	Convert integer length, in ASCII/nonary format to integer.
;	Do not use macro here...
;	Read string aNonaryLength, convert to integer, and store in length


    mov esi, aNonaryLength

    ; Skip spaces loop
leading_space_loop:
    movzx ecx, byte [esi]
    cmp ecx, ' '
    jne convertLoop
    inc esi
    jmp leading_space_loop

; Load the current character (digit) from the string
; Check for null (null terminator)
; Convert the character from ASCII to its corresponding numerical value
; Multiply the current result by 9 (base of the original number)
; Add the current digit to the result
convertLoop:
    movzx ecx, byte [esi]
    cmp ecx, 0
    je convertEnd
    sub ecx, '0'
    imul eax, eax, 9
    add eax, ecx
    inc esi
    jmp convertLoop
convertEnd:
    mov dword[length], eax


; -----
;  Convert radii from ASCII/nonary format to integer.
;  STEP #2 must complete before this code.

	mov	ecx, dword [length]
	mov	rdi, 0					; index for array
	mov	rbx, edgeLengths
cvtLoop:
	push	rbx					; safety push's
	push	rcx
	push	rdi
	aNonary2int	rbx, tmpInteger	
	pop	rdi
	pop	rcx
	pop	rbx

	mov	eax, dword [tmpInteger]
	mov	dword [edgeLenInts+rdi*4], eax		

	
	mov	eax, dword [edgeLenInts+rdi*4]   	; Load the edge length into EAX
	imul eax, eax
	imul eax, dword [edgeLenInts+rdi*4]   
	mov	dword [volumes+rdi*4], eax       	

	add	rbx, STR_LENGTH

	inc	rdi
	dec	ecx
	cmp	ecx, 0
	jne	cvtLoop

; -----
;  Display each the volumes array (five per line).

	mov	ecx, dword [length]
	mov	rsi, 0
	mov	r12, 0
printLoop:
	push	rcx					; safety push's
	push	rsi
	push	r12

	int2aNonary	dword [volumes+rsi*4], tempString, STR_LENGTH,spaces

	printString	tempString
	printString	spaces
	pop	r12
	pop	rsi
	pop	rcx
	inc	r12
	cmp	r12, 3
	jne	skipNewline
	mov	r12, 0
	printString	newLine
skipNewline:
	inc	rsi

	dec	ecx
	cmp	ecx, 0
	jne	printLoop
	printString	newLine

; -----
;  STEP #3
;	Find volumes array stats (sum, min, max, and average).
;	Reads data from volumes array (set above).


; --------------- Minimum, maximum, sum, and average for Volumes ---------------
; load the length into ECX
; load base address into EAX
; Start loop
; Load the Volume Array into EDX
; Add the current value to the sum
; Check for minimum
; if not, then check for Max
; Check for Maximum  
    mov ecx, [length]
    mov esi, 0
    mov edx, [volumes]
    mov [cubeMin], edx
    mov [cubeMax], edx
va_loop:
    mov eax, [volumes + esi * 4]
    add [cubeSum], eax
    cmp eax, [cubeMin]
    jb va_update_min
    cmp eax, [cubeMax]
    ja va_update_max
    jmp va_continue
va_update_min:
    mov [cubeMin], eax
    jmp va_continue
va_update_max:
    mov [cubeMax], eax
va_continue:
    inc esi
    loop va_loop

; ----------------------- Calculate average -----------------------
; Load Sum into EAX
; Load length into EBX
; check if not divideing by 0
; Sign-Extend EDX:EAX
; Divide EAX by EAX
; Store result in laAve
xor eax, eax
xor ebx, ebx
mov eax, dword[cubeSum]   
mov ebx, dword[length]  
cmp ebx, 0
je divideBy_zero
xor edx, edx    
div ebx         
mov dword[cubeAve], eax           
divideBy_zero:

; -----
;  STEP #4
;	Convert sum to ASCII/nonary for printing.
;	Do not use macro here...

	printString	shdr				; display header

;	Read volumes sum inetger (set above), convert to
;		ASCII/nonary and store in cubeSumString.
;	The ASCII version of the number should be STR_LENGTH
;		(globally available constant) characters (including the NULL),
;		right justified with the appropriate number of leading blanks.

; Clear the EDX register
; Divide the value in EDX:EAX by EAX
; Push the remainder
; Increemnt rcx
; compare eax of quotient with 0

	mov	eax, dword [cubeSum]      
	mov	rcx, 0                   
	mov	ebx, 9  

divideLoop:
	mov	edx, 0                 
	div	ebx                      
	push	rdx               
	inc	rcx              
	cmp	eax, 0                  
	jne	divideLoop               

mov rbx, cubeSumString
mov rdi, 0

mov r10, STR_LENGTH
sub r10, 1
mov r11, r10
sub r10, rcx
add al, " "

spaceLoop:
	mov byte[rbx +rdi], al
	inc rdi
	cmp rdi, r10
	jne spaceLoop

; Convert remainders to ASCII and store in cubeSumString
; Pop the top value into RAX
; Convert the value in al
; Store ASCII character 
; increment dl
; Next memory
    
popLoop:
	pop	rax                     
	add	al, '0'                 
	mov	byte [rbx+rdi], al      
	inc rdi
	cmp rdi, r11          
	jne	popLoop    

mov byte[rbx + rdi], NULL


; Print the cubeSumString
printString	cubeSumString


;  Convert average, min, and max integers to ASCII/nonary for printing.
;  STEP #5 must complete before this code.

	printString	avhdr
	int2aNonary	[cubeAve], cubeAveString, STR_LENGTH, spaces	
	printString	cubeAveString

	printString	minhdr
	int2aNonary	 [cubeMin], cubeMinString, STR_LENGTH, spaces	
	printString	cubeMinString

	printString	maxhdr
	int2aNonary	 [cubeMax], cubeMaxString, STR_LENGTH, spaces	
	printString	cubeMaxString

	printString	newLine
	printString	newLine

; *****************************************************************
;  Done, terminate program.

last:
	mov	rax, SYS_exit
	mov	rdi, EXIT_SUCCESS
	syscall
