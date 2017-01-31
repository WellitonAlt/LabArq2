INCLUDE Irvine32.inc

.data
 outHandle    DWORD ? 
 scrSize COORD <120,50> 

 Ctrl BYTE 0
 Tempo DWORD ?

 Fila0 BYTE 0, 0, 0, 0, 0, 0, 0, 0
 Fila1 BYTE 1, 0, 0, 0, 0, 0, 0, 0
 Fila2 BYTE 0, 0, 0, 0, 0, 0, 0, 0

 ZepX BYTE 4
 ZepY BYTE 4
 Zep BYTE  32, 254, 254 ,254, 254, 254, 254, 254,  32,
		  254, 254, 254, 254, 254, 254, 254, 254, 254,
		  254, 254, 254, 254, 254, 254, 254, 254, 254,
		   32, 254,  32, 254,  32, 254,  32, 254,  32,
		   32,  32, 254, 254, 254, 254, 254,  32,  32 

 AviaoX BYTE 4
 AviaoY BYTE 10
 Aviao BYTE 254, 254,  32 ,254, 254, 254,  32,  32, 32,
			254, 254,  32, 254,  32, 254,  32, 254, 32,
			 32, 254, 254, 254, 254, 254, 254, 254, 32,
			 32,  32,  32,  32,  32, 254,  32, 254, 32
 .code

Gera_Zep PROC
	call Randomize
	mov  eax, 3 
    call RandomRange 

	.IF Ctrl == 1
		mov eax, 3
	.ELSEIF Ctrl == 0
		mov Ctrl, 1
	.ENDIF
 
    .IF eax == 0
	    mov Fila0[7], 0
		mov Fila1[7], 2
		mov Fila2[7], 2
	.ELSEIF eax == 1
		mov Fila0[7], 2
		mov Fila1[7], 0
		mov Fila2[7], 2
	.ELSEIF eax == 2
		mov Fila0[7], 2
		mov Fila1[7], 2
		mov Fila2[7], 0
	.ELSEIF eax == 3
		mov Fila0[7], 0
		mov Fila1[7], 0
		mov Fila2[7], 0
		mov Ctrl, 0
	.ENDIF
	
		
	ret		
Gera_Zep ENDP

Move_Aviao PROC

	.IF AviaoY == 4 && Fila0[0] == 0
		mov Fila0[0], 1
		mov Fila1[0], 0
		mov Fila2[0], 0
	.ELSEIF AviaoY == 10 && Fila1[0] == 0
	    mov Fila0[0], 0
		mov Fila1[0], 1
		mov Fila2[0], 0
	.ELSEIF AviaoY == 16 && Fila2[0] == 0	
		mov Fila0[0], 0
		mov Fila1[0], 0
		mov Fila2[0], 1
	.ELSE
		call Colisao
	.ENDIF

	ret
Move_Aviao ENDP

Move_ZEP PROC    
	
	mov ecx, 8
	mov ebx, 0	
L0:	
	mov al, Fila0[ebx + 1]
	.IF Fila0[ebx] == 1 && al == 2
	     call Colisao
	.ELSEIF Fila0[ebx] != 1
		mov Fila0[ebx], al	
	.ENDIF	
	inc ebx
LOOP L0

	mov ecx, 8
	mov ebx, 0	
L1:	
	mov al, Fila1[ebx + 1]
    .IF Fila1[ebx] == 1 && al == 2
	     call Colisao
	.ELSEIF Fila1[ebx] != 1
		mov Fila1[ebx], al	
	.ENDIF
		
	inc ebx
LOOP L1

	mov ecx, 8
	mov ebx, 0	
L2:	
	mov al, Fila2[ebx + 1]
    .IF Fila2[ebx] == 1 && al == 2
	     call colisao	
	.ELSEIF Fila2[ebx] != 1
		mov Fila2[ebx], al
	.ENDIF		
	inc ebx
LOOP L2

	call Gera_Zep
	call Escreve_Fila
	ret
Move_Zep ENDP

Escreve_Fila PROC
	mov ecx, 7
	mov ebx, 0

L0:
	push ecx
	mov al, Fila0[ebx]
	;movzx eax, Fila0[ebx]
	;call WriteDec
	.IF al == 2
		call Desenha_Zep
	.ELSEIF al == 0
		call Apaga_Zep
	.ELSEIF al == 1
		call Desenha_Aviao
   .ENDIF
	pop ecx		
	add ZepX, 11
	inc ebx
LOOP L0

	;call Crlf
	mov ZepX, 4
	add ZepY, 6
	mov ecx, 7
	mov ebx, 0

L1:
	push ecx
	mov al, Fila1[ebx]
	;movzx eax, Fila1[ebx]
	;call WriteDec
	.IF al == 2
		call Desenha_Zep
	.ELSEIF al == 0
		call Apaga_Zep
	.ELSEIF al == 1
		call Desenha_Aviao
	.ENDIF
	pop ecx		
	add ZepX, 11
	inc ebx
LOOP L1
	
	;call Crlf
	mov ZepX, 4
	add ZepY, 6
	mov ecx, 7
	mov ebx, 0

L2:
	push ecx
	;movzx eax, Fila2[ebx]
	mov al, Fila2[ebx]
	;call WriteDec
	.IF al == 2
		call Desenha_Zep
	.ELSEIF al == 0
		call Apaga_Zep
	.ELSEIF al == 1
		call Desenha_Aviao
	.ENDIF
	pop ecx		
	add ZepX, 11
	inc ebx
LOOP L2
    
	;call Crlf
	mov ZepX, 4
	mov ZepY, 4
 		
	ret
Escreve_Fila ENDP

Desenha_Aviao PROC

	mov dl, AviaoX
	mov dh, AviaoY
	call GotoXY

	mov ecx, 4
	mov esi, OFFSET Aviao

Linha: 	
	PUSH ecx
	mov ecx, 9
	Coluna:
		mov  eax,red
		call SetTextColor
		mov al, [ESI]
		call WriteChar
		inc ESI
	LOOP Coluna
	POP ecx
	inc dh
	call GotoXY	
LOOP Linha
	
	ret
Desenha_Aviao ENDP

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
		mov  eax,green
		call SetTextColor
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

Apaga_Aviao PROC
	
	mov dl, AviaoX
	mov dh, AviaoY
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
Apaga_Aviao ENDP

Colisao PROC
	exit
Colisao ENDP

main PROC	
    INVOKE GetStdHandle,STD_OUTPUT_HANDLE 
	mov outHandle, eax

	INVOKE SetConsoleScreenBufferSize, 
	outHandle,scrSize
	
	call Gera_Zep
	call Escreve_Fila

	call GetMseconds
	mov Tempo,eax

Setas:
    mov  eax,50          
    call Delay        
	call ReadKey        
	    	
    .IF ah == 48h && AviaoY != 4		
		call Apaga_Aviao
		sub AviaoY, 6
		call Move_Aviao
		call Desenha_Aviao		
	.ELSEIF ah == 50h && AviaoY != 16
	    call Apaga_Aviao
		add AviaoY, 6
		call Move_Aviao
		call Desenha_Aviao	          	
	.ENDIF

	call GetMseconds
	sub eax, Tempo
	.IF eax > 500
	   call Move_Zep
	   call GetMseconds
	   mov Tempo, eax
	.ENDIF

    cmp dx,VK_ESCAPE
 jne Setas   		


	 

	exit
main ENDP
END main
