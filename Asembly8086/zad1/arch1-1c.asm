;=============================================================================;
;                                                                             ;
; Plik           : arch1-1c.asm                                               ;
; Format         : COM                                                        ;
; Cwiczenie      : Kompilacja, konsolidacja i debugowanie programów           ;
;                  asemblerowych                                              ;
; Autorzy        : Imie Nazwisko, Imie Nazwisko, grupa, dzien, godzina zajec  ;
; Data zaliczenia: DD.MM.ROK                                                  ;
; Uwagi          : Program obliczajacy wzor: (a-b)*c/d                        ;
;                                                                             ;
;=============================================================================;

                .MODEL TINY
a               EQU      20
b               EQU     10
c               EQU     100
d               EQU     5

Kod             SEGMENT

                ORG    100h
                ASSUME   CS:Kod, DS:Kod, SS:Kod

Start:
                jmp     Poczatek

Wynik           DW      90h

Poczatek:
                mov     ax,a
                mov     bx,b
                sub     ax,bx
                mov     cx,c
                mul     cx
                mov     cx,d
                div     cx

                mov     WORD PTR Wynik,ax
                mov     ax,4C00h
                int     21h
kod ENDS
END start

