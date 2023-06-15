
			.MODEL	SMALL,	C ;jezyk C naming convention-podczas kompilacji do nazw wsztskich funckji na poczatku podkreslenie
								;drugi argument to jezyk wyokiego poziomu z ktorym kompilator ma zachowac zgodnosc	
.CODE ;uproszczona dyrektywa segmentowa aby nie musiec znac zawilych specyfikacji kompilatorow a anzwy segmentow musza byc zgodne miedzy modulami 
;.CODE [nazwa] nazwa dla modelu MEDIUM HUGE LARGE kilka segmentow kodu musza miec nazwy		
			PUBLIC	srednia ;dane oraz procedury ktore maja byc dostpene z innych modulow-zadeklarowane za pomoca dyrektywy PUBLIC jako publiczne
			PUBLIC charcounter

;ramka stosu-obszar przeznaczony na parametry wyolania zmienne lokalne zawiera adres powrotu oraz oryginalna wartosc BP
srednia		PROC  ;procedura srednia 
		
			push bp ;na stos stara wartosc BP rejestr bazowy sluzy do adresowania danych w ramce stosu,aby nie utraccic ramki stosu procedury wywolujacej
			mov  bp,sp ;ustawiam bp na wartosc sp czyli szczyt stosu;
		
			mov si, [bp+4] ; do si przesuwam offset pierwszego elementu tablicy przeslany przez funkcje 
			mov cx, [bp+6] ; do cx przesuwam  (rozmiar tablicy)
			fldz ;push 0.0 na stos koprocesora 
		
petla:
			fadd DWORD PTR [si] ;
			add  si, 4 ; do si dodaje 4 bajty wtedy si wskazuje na kolejny element tablicy 
			loop petla 
		
		
			fidiv WORD PTR [bp+6] ; 	Divide ST(0) by m32int and store result in ST(0).
		
			;mov sp,bp ;ustawiam wierzcholek stosu na bp sciagam ze stosu zmienne lokalne
			pop bp ;sciagam oryginalne bp ze stosu 
			ret ;skok do adresu powrotu umieszczonego na stosie 
srednia		ENDP

charcounter		PROC

			push	bp			;zachowanie starej wartości BP
			mov		bp, sp		;i ustawienie nowej na aktualny wierzchołek stosu
			sub 	sp, 2		;zarezerwowanie na stosie 2 bajtow na zmienna lokalna stos "rosnie ku malejacym adresom"

			mov		si,	[bp+4]	;przesuwa do si offest pierwszego znaku  z tablicy
			mov		word ptr [bp-2], 0 ;ustawienie zmiennej lokalnej zliczacej ilosc wystapien znaku

ifequal:
			mov 	al, [si]	;wczytaj znak z tablicy	
			cmp		al, 00h		;czy znak to koniec lini
			je		return		;tak - skok

			cmp		al, byte ptr[bp+6]		;sprawdza czy wczytywany znak to ten poszukiwany
			jne		continue		;nie - skok

			inc		word ptr [bp-2]	;tak - zwiększ liczbe znalezionych znakow o 1

continue:
			
			inc		si
			jmp		ifequal
			
return:
			mov 	ax, [bp-2]	;przepisanie do ax wartosci ze zmiennej lokalnej
								;int zwracay jest w rejestrze AX
			
			
			mov		sp, bp		;zdjęcie ze stosu zmiennych lokalnych
			pop		bp			;odtworzenie starej
			
			ret					;powrót z procedury

charcounter		ENDP
			END