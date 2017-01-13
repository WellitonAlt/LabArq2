INCLUDE Irvine32.inc

.data
 X BYTE 5
 Y BYTE 5
.code
main PROC	
	mov  dl, X  ;column
    mov  dh, Y  ;row
	call Gotoxy

LookForKey:
    mov  eax,50          ; sleep, to allow OS to time slice
    call Delay           ; (otherwise, some key presses are lost)

	call ReadKey         ; look for keyboard input
    jz   LookForKey      ; no key pressed yet	

    .IF ah == 48h		
		mov  al,'C'
		call Clrscr 
		dec Y
		mov  dl, X 
		mov  dh, Y
		call Gotoxy
		call WriteChar
	.ELSEIF ah == 50h
		mov  al,'B'
		call Clrscr
		inc Y
		mov  dl, X 
		mov  dh, Y
		call Gotoxy
		call WriteChar
	.ENDIF

    cmp    dx,VK_ESCAPE  ; time to quit?
    jne    LookForKey    ; no, go get next key.   

	
	exit
main ENDP
END main