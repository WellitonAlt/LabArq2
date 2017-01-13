INCLUDE Irvine32.inc

.data
 Aviao0 BYTE 254, 254, 32 ,254, 254, 254
 Aviao1 BYTE 254, 254, 32, 254, 32, 254, 32, 254
 Aviao2 BYTE 32, 254, 254, 254, 254, 254, 254, 254
 Aviao3 BYTE 32, 32, 32, 32, 32, 254, 32, 254
 .code
main PROC	

	mov ecx, LENGTHOF Aviao0
	mov esi, OFFSET Aviao0
L0:
	mov al, [ESI]
	call WriteChar
	inc ESI
	LOOP l0

	call Crlf
	mov ecx, LENGTHOF Aviao1
	mov esi, OFFSET Aviao1

L1:
	mov al, [ESI]
	call WriteChar
	inc ESI
	LOOP l1
	
	call Crlf
	mov ecx, LENGTHOF Aviao2
	mov esi, OFFSET Aviao2
L2:
	mov al, [ESI]
	call WriteChar
	inc ESI
	LOOP l2

	call Crlf
	mov ecx, LENGTHOF Aviao3
	mov esi, OFFSET Aviao3
L3:
	mov al, [ESI]
	call WriteChar
	inc ESI
	LOOP l3
	
	mov eax, 3000
	call Delay

	mov ecx, 4
	mov al, 32
	mov dl, 0
	mov dh, 0
	call GotoXY

LL:
	PUSH ecx
	mov ecx, 9
	LR:
		call WriteChar
	LOOP LR
	POP ecx
	call Crlf
	LOOP LL

		call Delay


	exit
main ENDP
END main