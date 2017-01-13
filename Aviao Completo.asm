INCLUDE Irvine32.inc

.data
 AviaoX BYTE 2
 AviaoY BYTE 2
 Aviao0 BYTE 254, 254, 32 ,254, 254, 254
 Aviao1 BYTE 254, 254, 32, 254, 32, 254, 32, 254
 Aviao2 BYTE 32, 254, 254, 254, 254, 254, 254, 254
 Aviao3 BYTE 32, 32, 32, 32, 32, 254, 32, 254
 .code

Desenha_Aviao PROC

	mov dl, AviaoX
	mov dh, AviaoY
	call GotoXY

	mov ecx, LENGTHOF Aviao0
	mov esi, OFFSET Aviao0
L0:
	mov al, [ESI]
	call WriteChar
	inc ESI
	LOOP l0

	inc dh
	call GotoXY
	mov ecx, LENGTHOF Aviao1
	mov esi, OFFSET Aviao1
L1:
	mov al, [ESI]
	call WriteChar
	inc ESI
	LOOP l1
	
	inc dh
	call GotoXY
	mov ecx, LENGTHOF Aviao2
	mov esi, OFFSET Aviao2
L2:
	mov al, [ESI]
	call WriteChar
	inc ESI
	LOOP l2

	inc dh
	call GotoXY
	mov ecx, LENGTHOF Aviao3
	mov esi, OFFSET Aviao3
L3:
	mov al, [ESI]
	call WriteChar
	inc ESI
	LOOP l3
	
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