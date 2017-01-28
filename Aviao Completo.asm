INCLUDE Irvine32.inc

.data
 AviaoX BYTE 2
 AviaoY BYTE 2
 Aviao BYTE 254, 254, 32 ,254, 254, 254, 32, 32 ,32,
			254, 254, 32, 254, 32, 254, 32, 254, 32,
			32, 254, 254, 254, 254, 254, 254, 254, 32,
			32, 32, 32, 32, 32, 254, 32, 254, 32
 .code

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

Apaga_Aviao PROC
	
	mov dl, AviaoX
	mov dh, AviaoY
	call GotoXY
	
	mov ecx, 4
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

main PROC	
	
	call Desenha_Aviao

Setas:
    mov  eax,50          
    call Delay        

	call ReadKey        
    jz   Setas     	

    .IF ah == 48h		
		call Apaga_Aviao
		sub AviaoY, 4
		call Desenha_Aviao
	.ELSEIF ah == 50h
		call Apaga_Aviao
		add AviaoY, 4
		call Desenha_Aviao
	.ENDIF

    cmp dx,VK_ESCAPE
    jne Setas  

	exit
main ENDP
END main