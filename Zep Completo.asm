INCLUDE Irvine32.inc

.data
 outHandle    DWORD ? 
 scrSize COORD <120,50> 
 Teste BYTE ?
 ZepX BYTE 2
 ZepY BYTE 2
 Fila0 BYTE 0, 0, 0, 0, 0
 Fila1 BYTE 0, 0, 0, 0, 0
 Fila2 BYTE 0, 0, 0, 0, 0
 Zep0 BYTE 32, 254, 254 ,254, 254, 254, 254, 254
 Zep1 BYTE 254, 254, 254, 254, 254, 254, 254, 254, 254 
 Zep2 BYTE 32, 254, 32 ,254, 32, 254
 Zep3 BYTE 32, 254, 254, 254, 254, 254
 
 .code

Gera_Zep PROC
	call Randomize
	mov  eax, 3 
    call RandomRange 
    .IF eax == 0
	    mov Fila0[4], 0
		mov Fila1[4], 2
		mov Fila2[4], 2
	.ELSEIF eax == 1
		mov Fila0[4], 2
		mov Fila1[4], 0
		mov Fila2[4], 2
	.ELSEIF eax == 2
		mov Fila0[4], 2
		mov Fila1[4], 2
		mov Fila2[4], 0
	.ENDIF
	
	ret		
Gera_Zep ENDP

Move_ZEP PROC

	mov ecx, 4
	mov ebx, 0
	
L1:	
	mov al, Fila0[ebx + 1]
	mov Fila0[ebx], al	
	inc ebx
	Loop L1

	call Gera_Zep
	ret
Move_Zep ENDP

Escreve_Fila PROC
	mov ecx, 4
	mov ebx, 0

L1:
	push ecx
	mov al, Fila0[ebx]
	.IF al == 2
		call Desenha_Zep
	.ELSEIF al == 0
		call Apaga_Zep
	.ENDIF
	pop ecx	
	
	add ZepX, 10
	inc ebx
	Loop L1

	mov ZepX, 2
	mov ZepY, 2

	call Crlf 
		
	ret
Escreve_Fila ENDP

Desenha_Zep PROC

	mov dl, ZepX
	mov dh, ZepY
	call GotoXY

	mov ecx, LENGTHOF Zep0
	mov esi, OFFSET Zep0
L0:
	mov al, [ESI]
	call WriteChar
	inc ESI
	LOOP L0

	inc dh
	call GotoXY
	mov ecx, LENGTHOF Zep1
	mov esi, OFFSET Zep1
L1:
	mov al, [ESI]
	call WriteChar
	inc ESI
	LOOP L1
	
	inc dh
	call GotoXY
	mov ecx, LENGTHOF Zep2
	mov esi, OFFSET Zep2
L2:
	mov al, [ESI]
	call WriteChar
	inc ESI
	LOOP L2

	inc dh
	call GotoXY
	mov ecx, LENGTHOF Zep3
	mov esi, OFFSET Zep3
L3:
	mov al, [ESI]
	call WriteChar
	inc ESI
	LOOP L3

	ret
Desenha_Zep ENDP

Apaga_Zep PROC
	
	mov dl, ZepX
	mov dh, ZepY
	call GotoXY
	
	mov ecx, 5
	mov al, 32
Linha:
	PUSH ecx
	mov ecx, 9
	Coluna:
		call WriteChar
		LOOP Coluna
	POP ecx
	inc dh
    call GotoXY
	LOOP Linha
	
	ret
Apaga_Zep ENDP





main PROC	
    INVOKE GetStdHandle,STD_OUTPUT_HANDLE 
	mov outHandle, eax

	INVOKE SetConsoleScreenBufferSize, 
	outHandle,scrSize 
	call Gera_Zep

L1:
	
	call Move_Zep
	call Escreve_Fila
		
	mov eax, 300
	call Delay
	jmp L1

	exit
main ENDP
END main