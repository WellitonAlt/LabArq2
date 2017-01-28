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
 Zep BYTE  32, 254, 254 ,254, 254, 254, 254, 254,  32,
		  254, 254, 254, 254, 254, 254, 254, 254, 254,
		  254, 254, 254, 254, 254, 254, 254, 254, 254,
		   32, 254,  32, 254,  32, 254,  32, 254,  32,
		   32,  32, 254, 254, 254, 254, 254,  32,  32
 
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
    call Gera_Zep
	
	mov ecx, 4
	mov ebx, 0	
L0:	
	mov al, Fila0[ebx + 1]
	mov Fila0[ebx], al	
	inc ebx
LOOP L0

	mov ecx, 4
	mov ebx, 0	
L1:	
	mov al, Fila1[ebx + 1]
	mov Fila1[ebx], al	
	inc ebx
LOOP L1

	mov ecx, 4
	mov ebx, 0	
L2:	
	mov al, Fila2[ebx + 1]
	mov Fila2[ebx], al	
	inc ebx
LOOP L2

	call Gera_Zep
	ret
Move_Zep ENDP

Escreve_Fila PROC
	mov ecx, 4
	mov ebx, 0

L0:
	push ecx
	mov al, Fila0[ebx]
	.IF al == 2
		call Desenha_Zep
	.ELSEIF al == 0
		call Apaga_Zep
	.ENDIF
	pop ecx		
	add ZepX, 20
	inc ebx
LOOP L0

	mov ZepX, 2
	add ZepY, 6
	mov ecx, 4
	mov ebx, 0

L1:
	push ecx
	mov al, Fila1[ebx]
	.IF al == 2
		call Desenha_Zep
	.ELSEIF al == 0
		call Apaga_Zep
	.ENDIF
	pop ecx		
	add ZepX, 20
	inc ebx
LOOP L1

	mov ZepX, 2
	add ZepY, 6
	mov ecx, 4
	mov ebx, 0

L2:
	push ecx
	mov al, Fila2[ebx]
	.IF al == 2
		call Desenha_Zep
	.ELSEIF al == 0
		call Apaga_Zep
	.ENDIF
	pop ecx		
	add ZepX, 20
	inc ebx
LOOP L2

	mov ZepX, 2
	mov ZepY, 2
 		
	ret
Escreve_Fila ENDP

Desenha_Zep PROC

	mov dl, ZepX
	mov dh, ZepY
	call GotoXY

	mov esi, OFFSET Zep
	mov ecx, 5
Linha:
	push ecx
	mov ecx, 9
	Coluna:
		mov al, [ESI]
		call WriteChar
		inc ESI
	LOOP Coluna
	pop ecx
	inc dh
	call GotoXY
LOOP Linha

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
L1:	
	;call Gera_Zep
	call Move_Zep
	call Escreve_Fila		
	mov eax, 500
	call Delay
	jmp L1

	exit
main ENDP
END main