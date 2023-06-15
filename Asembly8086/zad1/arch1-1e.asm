;=============================================================================;
;                                                                             ;
; Plik           : arch1-1e.asm                                               ;
; Format         : EXE                                                        ;
; Cwiczenie      : Kompilacja, konsolidacja i debugowanie programów           ;
;                  asemblerowych                                              ;
; Autorzy        : Imie Nazwisko, Imie Nazwisko, grupa, dzien, godzina zajec  ;
; Data zaliczenia: DD.MM.ROK                                                  ;
; Uwagi          : Program znajdujacy najwieksza liczbe w tablicy             ;
;                                                                             ;
;=============================================================================;

                .MODEL  SMALL

DL_TABLICA      EQU     12

Dane            SEGMENT

Tablica         DB     04h, 02h, 04h, 10h, 12h, 33h
                DB     15h, 09h, 11h, 08h, 0Ah, 02h
				
Najwieksza      DB      ?

Dane            ENDS

Kod             SEGMENT

                ASSUME  CS:Kod, DS:Dane, SS:Stosik

Start:
                mov     ax, SEG Dane
				mov     ds, ax

                mov     bx, OFFSET Tablica
                mov     cx, DL_TABLICA
				mov     al, [bx]
Petla:
                inc		bx
				mov     ah,[bx]
				cmp     ah,al
                jbe      Skok
                mov     al, [bx]
Skok:
                loop    Petla

                mov     BYTE PTR Najwieksza,al

                mov     ax, 4C10h
                int     21h

Kod          	ENDS

Stosik          SEGMENT STACK
                DB      100h DUP (?)

Stosik        ENDS
END start

