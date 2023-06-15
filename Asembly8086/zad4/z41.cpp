#include <iostream.h>
#include <dos.h>
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>

typedef unsigned char BYTE;
typedef unsigned int  WORD;
typedef unsigned long DWORD;
typedef unsigned int  UINT;
typedef unsigned long LONG; 

unsigned char far* video_memory = (BYTE *)0xA0000000L;				// wskaznik daleki (far*) adresuje pamiec spoza aktualnego segmentu (pamiec ekranu) pierwszy adres tego bufora
unsigned long pixels = 0;

struct BITMAPFILEHEADER
{
UINT  bfType; 	   // Opis formatu pliku. Musi byc ‘BM’. Informuje nas, że mamy do czynienia z plikiem bmp.
DWORD bfSize; 	   // Rozmiar pliku BMP w bajtach.
UINT  bfReserved1; // Zarezerwowane. Musi byc równe 0.
UINT  bfReserved2; // Zarezerwowane. Musi byc równe 0.
DWORD bfOffBits;   // Przesuniecie w bajtach poczatku danych obrazu liczone od konca struktury
};

struct BITMAPINFOHEADER
{
DWORD biSize; 		   // Rozmiar struktury BITMAPINFOHEADER.
// dlugosc kazdej linii obrazu musi byc wielokrotnoscia 4 bajtow
LONG  biWidth; 		   // Szerokosc bitmapy w pikselach.
LONG  biHeight; 	   // Wysokosc bitmapy w pikselach.
WORD  biPlanes; 	   // Ilosc plaszczyzn. Musi byc 1.
WORD  biBitCount; 	   // Glebia kolorow w bitach na piksel. Moze wynosic 1,4,8 lub 24. W naszym przypadku wynosi 8. Kolejne skladowe sa umieszczone w pliku w kolejnosci BGR.
// W przypadku 24 bitowej glebii kolorow nie korzystamy z palety, a kazde 3 kolejne bajty obrazu oznaczaja skladowe BGR danego piksela.
DWORD biCompression;   // Rodzaj kompresji (u nas 0 – brak). Można zastosowac kompresje bezstratna RLE (Run-Length Encoding).
DWORD biSizeImage;	   // Rozmiar obrazu w bajtach. Uwaga moze byc 0.
LONG  biXPelsPerMeter; // Rozdzielczosc pozioma w pikselach na metr.
LONG  biYPelsPerMeter; // Rozdzielczosc pionowa w pikselach na metr.
DWORD biClrUsed; 	   // Ilosc uzywanych kolorow z palety. My wykorzystujemy w naszej palecie 256 kolorow.
DWORD biClrImportant;  // Ilosc kolorow z palety niezbednych do wyswietlenia obrazu (czyli inaczej liczba kolorow uzyta w bitmapie). Zero oznacza, ze wszystkie sa niezbedne.
};

// 
struct RGBQUAD
{
BYTE rgbBlue;		// niebieski
BYTE rgbGreen;		// zielony
BYTE rgbRed;		// czerwony
BYTE rgbReserved;	// wartosc zarezerwowana zawsze rowna 0
};

void SwitchModes(unsigned short int on)
{
	REGPACK regs;				// struktura REGPACK jest czescia dos.h
	if(on) regs.r_ax = 0x13;	// wpisujemy do rejestru ax kod trybu graficznego = 13h
	else regs.r_ax = 0x10;		// lub kod trybu tekstowego = 10h
	intr(0x10, &regs);			// przerwanie uruchamiajace nasz tryb graficzny
}

/*Aby ustawić kolor na palecie kolorów karty VGA musimy wysłać do portu 03C8H numer koloru,
a następnie wysyłać po kolei dane RGB (Red Green Blue) bajt po bajcie do portu 03C9H.
Aby odczytać natężenia składowe danego koloru musimy wysłać do portu 03C7H numer koloru,
a nastepnie odczytywać dane RGB bajt po bajcie z portu 03C9H.

W celu odczytania aktualnej pozycji z palety kolorów należy do portu 3C7h
wysłać numer wpisu, a z portu 3C9h odczytać kolejno składowe: czerwoną, zieloną i
niebieską. Jeżeli chcemy zmienić wpis w palecie kolorów, musimy do portu 3C8h wysłać
numer pozycji w palecie, a do portu 3C9h wpisać kolejno składowe: czerwoną, zieloną i
niebieską.

Oferuje on grafikę o rozdzielczości 320 na 200 pikseli w 256 kolorach opisanych za pomocą
struktury zwanej paletą kolorów. Zatem informacja o kolorze dowolnego piksela zajmuje
dokładnie jeden bajt i jest to liczba identyfikująca wpis w aktualnej palecie kolorów. Z kolei
każdy wpis znajdujący się w palecie opisuje składowe RGB koloru, przy czym każda
składowa może przyjmować wartości z przedziału od 0 do 63. Stąd też tryb ten charakteryzuje
się dużą prostotą obsługi. Pamięć ekranu dla trybu 13h znajduje się pod adresem
0A000h:0000h i zajmuje dokładnie 640000 bajtów
*/



void setPalette()
{
	// definiujemy nasza palete
	RGBQUAD * palette = new RGBQUAD[256]; // mamy 256 kolorow w naszej 8 bitowej palecie
	for(int i = 0; i <= 255; i++)
	{
		// nadajac poszczegolnym skladowym koloru rowne wartosci uzyskujemy skale szarosci (kolor czarny to ma skladowe 0,0,0, a kolor bialy 255,255,255)
		palette[i].rgbBlue = i;
		palette[i].rgbGreen = i;
		palette[i].rgbRed = i;
		palette[i].rgbReserved = 0; //zawsze rowne zero
	}
	// ustawiamy aktualna palete kolorow 
	outportb(0x03C8, 0); 			// rozpocznij ustawianie palety od koloru nr 0
    for (int j = 0; j <= 255; j++)  // ilosc kolorow w palecie 8-bitowej = 256
    {
        outp(0x03C9, palette[j].rgbRed * 63 / 255); // skalowana składowa R one way to interface input/output devices to a computer is via IO ports - comands and data are writen and status information and data read. In this case 0x3F8 is the base addess of the COM0: serial port on a PC. the function call
        outp(0x03C9, palette[j].rgbGreen * 63 / 255); // skalowana składowa G
        outp(0x03C9, palette[j].rgbBlue * 63 / 255); // skalowana składowa B
    }
	delete palette;
}

void dispalay(char * picture)
{
	FILE * bitmap_file;    // plik bitmapy
	BITMAPFILEHEADER bmpf; // pierwszy naglowek bitmapy
	BITMAPINFOHEADER bmpi; // drugi naglowek bitmapy
	bitmap_file = fopen(picture, "rb"); 						// otworz plik do odczytu w trybie binarnym "rb" (r - read, b - binary)
	fread(&bmpf, sizeof(BITMAPFILEHEADER), 1, bitmap_file); // odczytaj z pliku pierwszy naglowek i zapamietaj w zmiennej bmfh, liczba 1 okresla odczytanie dokladnie jednego bloku danych o rozmiarze rownym drugiemu argumentowi funkcji
	fread(&bmpi, sizeof(BITMAPINFOHEADER), 1, bitmap_file); // odczytaj z pliku drugi naglowek i zapamietaj w zmiennej bmih
	fseek(bitmap_file, bmpf.bfOffBits, SEEK_SET);			// przesuniecie pozycji wskaznika w strumieniu danych pliku o wartosc bfOffBits, od pozycji rownej trzeciemu argumentowi funkcji, SEEK_SET oznacza poczatek pliku
	setPalette();									// ustawiamy palete
	pixels = bmpi.biHeight * bmpi.biWidth;	// obliczamy ilosc pikseli
	// obraz wyswietlamy od konca, poniewaz w pliku bmp jest on zapisany w kolejnosci od ostatniego do pierwszego piksela
    for(int y = bmpi.biHeight; y > 0; y--)					// wysokosc obrazu = 200
    {
        for(int x = bmpi.biWidth; x > 0; x--)				// szerokosc obrazu = 300
        {
            video_memory[y * 320 - x]=fghhhg  hjnnolllbghhi,ml;m;k;mmk; mketc(bitmap_file); // pobranie danej z aktualnej pozycji wskaznika strumienia pliku .bmp, zaladowanie do pamieci ekranu i przesuniecie wskaznika na kolejny znak
        }
    }
    fclose(bitmap_file);			// zamkniecie pliku
}

void Negative()
{
    for(long i = 0; i < pixels; i++)  // 200*320=64000 pikseli
    {
        video_memory[i] = ~video_memory[i];    // negacja
    }
}

void Brightness(BYTE factor = 50)
{
	for(long i = 0; i < pixels; i++)  // 200*320=64000 pikseli
    {
        if (video_memory[i] + factor > 255) video_memory[i] = 255;  // nie mozemy przekroczyc wartosci = 255
		else if (video_memory[i] + factor < 0) video_memory[i] = 0; // gdyby wspolczynnik byl ujemny, to nie mozemy przekroczyc wartosci = 0
		else video_memory[i] += factor;
    }
}

void Contrast(int constant = 2)
{
	double avg;
	double sub;
	for(long i = 0; i < pixels; i++)  // 200*320=64000 pikseli
    {
		avg += (double)video_memory[i];
    }
	avg = avg / (double)pixels;
	sub = (double)constant * avg;
	
	for(long j = 0; j < pixels; j++)  // 200*320=64000 pikseli
    {
        if (video_memory[j] * constant - (int)sub > 255) video_memory[j] = 255;  // nie mozemy przekroczyc wartosci = 255
		else if (video_memory[j] * constant - (int)sub < 0) video_memory[j] = 0; // nie mozemy przekroczyc wartosci = 0
		else video_memory[j] = video_memory[j] * constant - (int)sub;
    }
}

void thresholding(int threshold=150)
{
	for(long i = 0; i < pixels; i++)
    {
        if(video_memory[i] > threshold)	// przyjmujemy graniczna wartosc progowania = 150
        {
            video_memory[i] = 0;
        }
    }
}

int main(){
	char * picture;
	unsigned short int choice;
	do{
		system("cls");
		cout<<"Choose photo: \n";
		cout<<"[1]Aero\n";
		cout<<"[2]Bridge\n";
		cout<<"[3]Lena\n";
		cout<<"[4]Boat\n";
		cout<<"[0]Exit\n";
		cin>>choice;
		while (choice < 0 || choice > 4)
		{
			cout << "No operation at number: "<<choice<<" try again: ";
			cin >> choice;
		}
		if(choice == 2) picture = new char [11]; // "bridge.bmp" jest dłuższą nazwą niż reszta
		else picture = new char [9];
		
		switch(choice)
		{
			case 1:
				picture = "aero.bmp";
				break;
			case 2:
				picture = "bridge.bmp";
				break;
			case 3:
				picture = "lena.bmp";
				break;
			case 4:
				picture = "boat.bmp";
				break;
			case 0:
				break;
		}
		system("cls");
		SwitchModes(1);
		dispalay(picture);
		getch();
		SwitchModes(0);
		do{
			if(choice!=0)
			{
				cout<<"Choose operation: \n";
				cout<<"[1]Negative\n";
				cout<<"[2]Brightness\n";
				cout<<"[3]Contrast\n";
				cout<<"[4]Thresholding\n";
				cout<<"[5]Return to photo selection\n";
				cout<<"[0]Exit\n";
				cin>>choice;
				while (choice < 0 || choice > 5)
				{
					cout << "No operation at number: "<<choice<<" try again: ";
					cin >> choice;
				}
			}
			system("cls");
			switch(choice)
			{
				case 1:
					system("cls");
					SwitchModes(1);
					dispalay(picture);
					Negative();
					choice=1;
					break;
				case 2:
					BYTE factor;
					cout<<"Brightness factor: ";
					cin>>factor;
					system("cls");
					SwitchModes(1);
					dispalay(picture);
					Brightness(factor);
					choice=2;
					break;
				case 3:
					int contrast;
					cout<<"Contrast constant: ";
					cin>>contrast;
					system("cls");
					SwitchModes(1);
					dispalay(picture);
					Contrast(contrast);
					choice=3;
					break;
				case 4:
					int threshold;
					cout<<"threshold: ";
					cin>>threshold;
					system("cls");
					SwitchModes(1);
					dispalay(picture);
					thresholding(threshold);
					choice=4;
					break;
				case 5:
					choice=5;
					break;
				case 0:
					choice=0;
					break;
					
			}
			getch();
			SwitchModes(0);
		}while(choice!=5 && choice!=0);
	}while(choice!=0);
	system("cls");
	delete[] picture;
	return 0;
}