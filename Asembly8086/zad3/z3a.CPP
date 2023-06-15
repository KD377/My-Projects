#include <iostream.h>
#include <stdlib.h>

extern "C" float srednia(float *array, int arr_size); //poniewaz naming convention w C++ jest bardziej skomplikowana to informujemy 
extern "C" int charcounter(char *array, char chr);//aby zachowac zgosnosc z konwencja nazewniczą jezyka C (dodanie podkreslenia na poczatku)

int main()
{
	char wybor;
	do
	{
		
		do
		{
			system("cls");
			cout<<"Wybierz opcje"<<endl;
			cout<<"Oblicz srednia [1]"<<endl;
			cout<<"Licznik znaku w tablicy [2]"<<endl;
			cout<<">>";
			cin>>wybor;
		}while(wybor!='1' && wybor!='2');
			switch(wybor){
				case '1':
				{
					int size;

					cout << endl << "Podaj rozmiar tablicy: ";
					cin >> size;

					float *tablica = new float[size];

					cout << "Podaj wartosci tablicy" << endl;

					for(int i = 0; i < size; i++) {
						cout << i+1 << ": ";
						cin >> tablica[i];
					}

					cout << endl << "Srednia wartosc: " << srednia(tablica, size) << endl;

					delete []tablica;
					break;
				}
				
				case '2':
				{
					char znak;
					char *tablica = new char[40];
					
					cout << endl << "Podaj lancuch tekstowy (max 40 znakow!): ";
					cin.sync();
					cin.getline(tablica, 40);
					
					cout << "Podaj poszukiwany znak: ";
					cin >> znak;	
					
					cout << "Ilosc wystapien znaku: " << charcounter(tablica, znak);
					
					delete []tablica;
					break;
				}
			}
			do
			{
				cout<<endl<<endl<<"Powrot do menu[1]"<<endl;
				cout<<"Zakoncz program[2]"<<endl;
				cin>>wybor;
			}while(wybor!='1' && wybor!='2');
	}while(wybor!='2');
		

	
	return 0;
}
