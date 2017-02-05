INCLUDE Irvine32.inc

.data
 outHandle    DWORD ? 
 scrSize COORD <85,50> 

 Ctrl BYTE 0
 Ctrl2 BYTE 0
 Tempo DWORD ?
 Pont WORD 0
 Atraso DWORD 500

 Pontuacao BYTE "Potuacao: ", 0

 Opcoes BYTE "				  1 - COMECAR",0ah, 0dh
        BYTE "				ESC - SAIR" ,0ah, 0dh
		BYTE "				" ,0ah, 0dh
		BYTE "				" ,0ah, 0dh
		BYTE "				" ,0ah, 0dh
		BYTE "				" ,0ah, 0dh
		BYTE "	AJUDA:	Use as SETAS par CIMA e para BAIXO para desviar dos Baloes", 0ah, 0dh
		BYTE "		para marcar o maior numero de pontos posivel, Boa Sorte :)",0
    		

 Fila0 BYTE 0, 2, 0, 0, 0, 2, 0, 0
 Fila1 BYTE 1, 0, 0, 2, 0, 0, 0, 0
 Fila2 BYTE 0, 2, 0, 0, 0, 2, 0, 0

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
 
 GameOver BYTE "		 _____                          ____                  ",0ah, 0dh                
		  BYTE "		/ ____|                        / __ \                 ",0ah, 0dh
		  BYTE "		| |  __  __ _ _ __ ___   ___  | |  | |_   _____ _ __  ",0ah, 0dh
	      BYTE "		| | |_ |/ _` | '_ ` _ \ / _ \ | |  | \ \ / / _ \ '__| ",0ah, 0dh
		  BYTE "		| |__| | (_| | | | | | |  __/ | |__| |\ V /  __/ |    ",0ah, 0dh
		  BYTE "		\______|\__,_|_| |_| |_|\___|  \____/  \_/ \___|_|    ",0
 
 Avion BYTE "			   	             _              ",0ah, 0dh
       BYTE "			       /\           (_)			    ",0ah, 0dh
       BYTE "			      /  \__   ___  ___  _ __	",0ah, 0dh
       BYTE "			     / /\ \ \ / / |/ _ \| '_ \	",0ah, 0dh
       BYTE "			    / ____ \ V /| | (_) | | | |	",0ah, 0dh
       BYTE "		           /_/    \_\_/ |_|\___/|_| |_|	",0

 .code

HUD PROC

	mov  eax, white
	call SetTextColor

	mov dl, 1
	mov dh, 1
	call GotoXY

	mov ecx, 80
	mov al, 220

	L1:
	  call WriteChar
	  inc dl
	  call GotoXY
	Loop L1

	mov dl, 2
	mov dh, 21
	call GotoXY

	mov ecx, 78
	L2:
	  call WriteChar
	  inc dl
	  call GotoXY
	Loop L2

	mov dl, 2
	mov dh, 24
	call GotoXY

	mov ecx, 78
	L3:
	  call WriteChar
	  inc dl
	  call GotoXY
	Loop L3

	mov dl, 1
	mov dh, 2
	call GotoXY

	mov ecx, 23
	mov al, 219

	L4:
	  call WriteChar
	  add dl, 79
	  call GotoXY
	  call WriteChar
	  inc dh
	  sub dl, 79
	  call GotoXY
	Loop L4


	ret
HUD ENDP

Atualiza_Pont PROC
	.IF Ctrl == 0
		add Pont, 5
		mov dl, 60
		mov dh, 23
		call GotoXY
		push eax
			mov  eax, white
			call SetTextColor
			movzx eax, Pont
			call WriteDec
		pop eax
	.ENDIF
	
	ret
Atualiza_Pont ENDP

Pontu PROC
	mov  eax, white
	call SetTextColor
	mov dl, 50
	mov dh, 23
	call GotoXY
	mov edx, OFFSET Pontuacao
    call WriteString 

	ret
Pontu ENDP


Atraso_Ctrl PROC
		movzx eax, Pont
		.IF eax > 50 && Ctrl2 == 0
			sub Atraso, 50
			inc Ctrl2
		.ELSEIF eax > 150 && Ctrl2 == 1
			sub Atraso, 50
			inc Ctrl2
		.ELSEIF eax > 300 && Ctrl2 == 2
			sub Atraso, 50
			inc Ctrl2
		.ELSEIF eax > 450 && Ctrl2 == 3
			sub Atraso, 50
			inc Ctrl2
		.ELSEIF eax > 600 && Ctrl2 == 4
			sub Atraso, 50
			inc Ctrl2
		.ENDIF
	ret
Atraso_Ctrl ENDP


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
	
	call Atualiza_Pont
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

	mov ZepX, 4
	add ZepY, 6
	mov ecx, 7
	mov ebx, 0

L1:
	push ecx
	mov al, Fila1[ebx]
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
	
	mov ZepX, 4
	add ZepY, 6
	mov ecx, 7
	mov ebx, 0

L2:
	push ecx
	mov al, Fila2[ebx]
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
	call Clrscr
	mov dl, 1
	mov dh, 7
	call GotoXY
	mov  eax, red
	call SetTextColor
	mov edx, OFFSET GameOver
    call WriteString 
	call HUD
	call Pontu
	mov dl, 60 
	mov dh, 23
	call GotoXY
	mov  eax, white
	call SetTextColor
	movzx eax, Pont
	call WriteDec
	mov eax, 2000
	call delay
	exit
Colisao ENDP

main PROC	
    INVOKE GetStdHandle,STD_OUTPUT_HANDLE 
	mov outHandle, eax

	INVOKE SetConsoleScreenBufferSize, 
	outHandle,scrSize
	
	mov dl, 1
	mov dh, 8
	call GotoXY
	mov  eax, white
	call SetTextColor
	mov edx, OFFSET Avion
    call WriteString
	mov dl, 1
	mov dh, 16
	call GotoXY
	mov edx, OFFSET Opcoes
    call WriteString	 
	call HUD
	
	mov ecx, 0

Op:	
    mov  eax,50          
    call Delay        
	call ReadKey
	push edx 

	.IF al == 31h
		call Clrscr
		 mov AviaoX, 4
         mov AviaoY, 10
		jmp Continua          	
	.ENDIF

	.IF ecx == 0 
		call Apaga_Aviao
		mov AviaoX, 3
		mov AviaoY, 3
	.ELSEIF ecx == 67
		mov ecx, -1
	.ENDIF
	 
	push ecx
		call Apaga_Aviao
		inc AviaoX
		call Desenha_Aviao
		mov eax, 80
		call Delay
	pop ecx
	inc ecx

	pop edx
    cmp dx,VK_ESCAPE
 jne OP
 je Sair
 Continua:

	call HUD	
	call Pontu
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

	call Atraso_Ctrl
	call GetMseconds
	sub eax, Tempo	
	.IF eax > Atraso
	   call Move_Zep
	   call GetMseconds
	   mov Tempo, eax
	.ENDIF

    cmp dx,VK_ESCAPE
 jne Setas   		
 Sair:
	exit
main ENDP
END main