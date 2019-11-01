; asmsyntax=nasm
;***************************************
;* BRAIN FUCK                          *
;***************************************

%include "constants.inc"

section .data

fnfMsg		db  "bfi: could not open "
fnfMsgLen	equ  $-fnfMsg
bracketMsg	db  "bfi: unbalanced brackets"
bracketMsgLen	equ  $-bracketMsg
lineFeed	db  LF
bufsize		dw	10240

mmap_arg:
  .addr:	dd 0
  .len:		dd 20484
  .prot:	dd 3
  .flags:	dd 34
  .fd:		dd -1
  .offset:	dd 0

section .bss

buf	resb	10240

section .text


global _start

;***************************************
;*  _start()                           *
;***************************************

%define	argc	[ebp+4]
%define	progname[ebp+8]
%define	fname	[ebp+12]
%define	argv	[ebp+4*ecx]
%define prgfloor[ebp-4]		; *prgfloor: points to bottom of stored code
%define memfloor[ebp-8]		; *memfloor: points to bottom of memory

_start:

  enter	8, 0

; ALLOCATING MEMORY

  mov	eax, 90
  lea	ebx, [mmap_arg]
  int	80h

  mov	memfloor, eax
  add	eax, 10240
  mov	prgfloor, eax

; OPENING INPUT CHANNEL

  cmp	dword argc, 2
  jne	.I

  mov	eax, SYS_OPEN
  mov	ebx, fname
  mov	ecx, O_RDONLY
  mov	edx, S_IRUSR | S_IRGRP | S_IROTH
  int	80h

  cmp	eax, 0
  jl	.filenotfound
  mov	ebx, eax  
  jmp	.i

.I:

  mov	ebx, STDIN

.i:

; INITIALIZING MEMORY
   
  mov	edi, memfloor
  mov	ecx, 5120
  mov	eax, 0
  rep stosd

; READING/PARSING INPUT TO PROGRAM MEMORY

  mov	eax, SYS_READ
  mov	ecx, prgfloor
  mov	edx, bufsize
  int	80h

  mov	esi, prgfloor
  xor	eax, eax
  xor	ecx, ecx
  xor	edx, edx

.P:
  cmp	ecx, 10240
  je	.p
  lodsb
  dec	esi
  mov	[esi], byte 0

  cmp	eax, '>'
  jne	.p1
  mov	[esi], byte 1
.p1:

  cmp	eax, '<'
  jne	.p2
  mov	[esi], byte 2
.p2:

  cmp	eax, '+'
  jne	.p3
  mov	[esi], byte 3
.p3:

  cmp	eax, '-'
  jne	.p4
  mov	[esi], byte 4
.p4:

  cmp	eax, '.'
  jne	.p5
  mov	[esi], byte 5
.p5:

  cmp	eax, ','
  jne	.p6
  mov	[esi], byte 6
.p6:

  cmp	eax, '['
  jne	.p7
  dec	edx
  mov	[esi], byte 7
.p7:

  cmp	eax, ']'
  jne	.p8
  inc	edx
  mov	[esi], byte 8
.p8:

  inc	esi
  inc	ecx

  jmp	.P

.p:

  mov	[esi], byte 9
  cmp	edx, 0
  jne	.b

; EXECUTE LOOP

  mov	edi, memfloor
  mov	esi, prgfloor
  dec	esi

.T:
  inc	esi
  movzx	eax, byte [esi]
  jmp	[.t+eax*4]

.t1:		; '>' :  ++ptr
  inc	edi
  jmp	.T

.t2:		; '<' :  --ptr
  dec	edi
  jmp	.T

.t3:		; '+' :	 ++*ptr
  inc	byte [edi]
  jmp	.T

.t4:		; '-' :  --*ptr
  dec	byte [edi]
  jmp	.T

.t5:		; '.' :  fputc(*ptr, stdout)
  mov	ecx, edi
  mov	eax, SYS_WRITE
  mov	ebx, STDOUT
  mov	edx, 1
  int	80h
  jmp	.T

.t6:		; ',' :  *ptr = fgetc(stdin)
  mov	ecx, edi
  mov	eax, SYS_READ
  mov	ebx, STDIN
  mov	edx, 1
  int	80h
  jmp	.T

.t7:		; '[' :  while (*ptr) {
  cmp	byte [edi], 0
  je	.tw
  push  esi
  jmp	.T

.tw:
  inc	esi
  cmp	byte [esi], 8
  jne	.tw
  jmp	.T

.t8:		; ']' :  }  /*ending while*/
  pop	esi
  dec	esi
  jmp	.T

  .t: DD .T, .t1, .t2, .t3, .t4, .t5, .t6, .t7, .t8, .e

.b:

  mov	ecx, bracketMsg
  mov	edx, bracketMsgLen
  call	R
  call	L

  jmp	.e

.filenotfound:

  mov	ecx, fnfMsg
  mov	edx, fnfMsgLen
  call	R

  mov	edi, fname
  
  xor	ecx, ecx
  not	ecx
  xor	eax, eax
  cld
  repne scasb
  neg	ecx
  lea	edx, [ecx-2]
  
  mov	ecx, fname
  call	R

  call	L

.e:
  mov	eax, SYS_CLOSE
  int	80h

  leave

  mov	eax, SYS_EXIT
  xor	ebx, ebx
  int	80h
  
;****************************************************************
;*  R - errprnt: prints string pointed to by ecx of length edx into stderr
;****************************************************************

R:
  mov	eax, SYS_WRITE
  mov	ebx, STDERR
  int	80h
  ret

;****************************************************************
;*  L - lnfd: prints a linefeed to stderr
;****************************************************************

L:
  mov	ecx, lineFeed
  mov	edx, 1
  call	R
  ret

  
