	.386p
	.MODEL TINY
	
Kod     	SEGMENT	USE16	;zeby uzywal rejestrow 16-bitowych
			ASSUME  CS:Kod, DS:Kod, SS:Kod
			ORG 100h

Start:
main PROC
		call getNumber  ;wywolanie funcji  Polecenie to powoduje umieszczenie na stosie adresu następnego rozkazu (tego, który następuje zaraz po tej instrukcji) i przekazuje sterowanie programem do określonego przez operand miejsca. Jeśli dana procedura nie występuje w tym samym segmencie, co jej wywołanie to na stosie umieqszczony jest segment i adres rozkazu po call. W przeciwnym wypadku umieszczony jest sam adres. Nazywane jest to kolejno wywołanie odległe i bliskie. System operacyjny Windows i Linux pracują w płaskim modelu pamięci zatem, tam domyślnie funkcjonuje typ bliskiego wywołania procedur.
		
		mov bx, OFFSET Buffer+2 ; umieszczam w bx adres pierwszego znaku stringa
		mov al,[bx] ;umieszczam w al pierwszy znak 
		cmp al,'-' ;porownuje 
		jne dodatnia ;jesli nie rowne ZF=0 wykonuje skok 
		mov bx,OFFSET Buffer+3 ;jesli ujemne umieszczam w bx pierwsza liczbe zaraz po minusie 
dodatnia:
		mov di, OFFSET Num1 ;umieszczam w di adres zmiennej 
		call str2num ;wywoluje procedure
		mov bx, OFFSET Buffer+2 
		mov al,[bx]
		cmp al,'-'
		jne dodatnia2
		mov ax, Num1	;jesli ujemna umieszczam wartosc bezwzgledna w ax i neguje by otrzymac kod U2 tej liczby 
		neg ax
		mov Num1, ax ; umieszczam w zmiennej 
dodatnia2:
		call getNumber	
		
		mov bx, OFFSET Buffer+2
		mov al,[bx]
		cmp al,'-'
		jne dodatnia3
		mov bx,OFFSET Buffer+3
dodatnia3:
		mov di, OFFSET Num2
		call str2num
		mov bx, OFFSET Buffer+2
		mov al,[bx]
		cmp al,'-'
		jne dodatnia4
		mov ax, Num2
		neg ax
		mov Num2, ax
dodatnia4:	
		mov dx,OFFSET NewLine ;do dx adres pierwszego elementu tablicy
		mov ah,09h	 ;do ah numer funkcji systemowej 09 ktora drukuje string zakonczony $
		int 21h ; przerwanie int 21  odłożenie na stos rejestru znaczników,
				;- wyzerowanie flagi zezwolenia na przerwania IF — tym samym
					;zablokowanie przyjmowania kolejnych zgłoszeń przerwań podawanych na
				;wejście INTR,
				;- odłożenie na stos bieżącej zawartości dwóch rejestrów: najpierw CS,
				;potem IP, czyli odłożenie adresu następnej instrukcji do wykonania w
				;ramach aktualnie realizowanego programu,
				;- załadowanie do rejestrów CS:IP adresu procedury obsługi zgłoszonego
				;przerwania i tym samym rozpoczęcie jej wykonywania.
		mov ax,Num2 ;do ax wartosc zmiennej num2
		mov bx,Num1 ; do bx wartosc zmiennej num1
		add ax, bx ;dodawanie i sprawdzenie czy wystapilo przepelnienie lub 
		jo  overflow ;jesli flaga of
		js  ujemna ;jesli flaga sf
		jmp Koniec ;skok bezwarunkowy 
overflow:
		js Koniec
ujemna:
		mov ebx, 0ffff0000h
		add bx,ax
		neg ebx
		
		mov dx,'-'
		mov ax,0200h
		int 21h
		
		mov eax,ebx
Koniec:
		mov ebx,10
		xor edx,edx
		div ebx
		add dx, '0'
		push dx
		inc cx
		cmp eax,0000h
		jne Koniec
Wypisz:		
		pop dx
		mov ax,0200h
		int 21h
		
		loop Wypisz
exit:		
		mov ax, 4c00h
		int 21h
		
		TEKST DB "Podaj liczbe:", 0Ah, 0Dh, ">>$"
		StrLen DB 8
		Buffer DB 8 DUP('$')
		NewLine DB 0Ah, 0Dh,0Ah,0Dh, "$"
		Num1 DW 0
		Num2 DW 0
		Wynik DD 0
		zmienna DD ?
		flaga DB 0
main ENDP

getNumber PROC
		mov dx, OFFSET TEKST
		mov ah, 09h
		int 21h
		
		mov dx, OFFSET Buffer
		mov Buffer ,8
		mov ah, 0Ah
		int 21h
		ret		
getNumber ENDP	

str2num PROC
		mov si, OFFSET Buffer+1
		mov cl,[si]
		;dec cx
		mov si, OFFSET Buffer+2
		mov al,[si]
		cmp al,'-'
		jne str2num1
		dec cx
		
str2num1:
		mov ax,0
		mov al,[bx]
		sub al,'0'
		add ax,[di]
		cmp cx,01h
		je  str2num2
		mov dx,0Ah
		mul dx
str2num2:
		mov [di], ax
		inc bx	
		loop str2num1

		ret
str2num ENDP


Kod ENDS	
END Start