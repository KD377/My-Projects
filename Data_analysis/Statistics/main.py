import numpy as np
from matplotlib import pyplot as plt
import csv
import pandas as pd
from tabulate import tabulate

with open("./data.csv", 'r') as file:
    csvreader = csv.reader(file)
    data = list(csvreader)

    def calculate_percentage(flower, number=150):
        return (flower / number) * 100

    def minimum(table, index):
        x = float(table[0][index])
        for i in range(len(table)):
            if float(table[i][index]) < x:
                x = float(table[i][index])
        return x

    def maksimum(table, index):
        x = float(table[0][index])
        for i in range(len(table)):
            if float(table[i][index]) > x:
                x = float(table[i][index])
        return x

    def average(table, index):
        counter = 0
        sum = 0
        for elements in range(len(table)):
            counter += 1
            sum += float(table[elements][index])
        return sum / counter

    def deviation(table, avg, index):
        sum = 0
        n = 0
        for i in range(len(table)):
            sum += (float(table[i][index])-float(avg)) ** 2
            n += 1
        return np.sqrt(sum / (n - 1))

    def mediana(table, index):
        values = []
        for i in range(len(table)):
            values.append(float(table[i][index]))
        x = len(values)
        values.sort()
        if (x % 2) == 0:
            return (float(values[int(x / 2)]) + float(values[int(x / 2)-1])) / 2
        if (x % 2) != 0:
            return float(values[int(x/2)])

    def Q1(table, index):
        values = []
        for i in range(len(table)):
            values.append(float(table[i][index]))
        x = len(values)
        values.sort()
        if (x % 4) == 0:
            return (float(values[int(x / 4)]) + float(values[int(x / 4)-1])) / 2
        if (x % 4) != 0:
            return float(values[int(x/4)])



    def Q3(table, index):
        values = []
        for i in range(len(table)):
            values.append(float(table[i][index]))
        x = len(values)
        values.sort()
        if (x % 4) == 0:
            return (float(values[int(x / 4) * 3]) + float(values[int(x / 4) * 3 - 1])) / 2
        if (x % 4) != 0:
            return float(values[int(x / 4) * 3])

    def set_bins(min_value, max_value, scale):
        tab = []
        i = min_value * 10
        while i <= max_value * 10:
            tab.append(i)
            i += (scale * 10)
        for x in range(len(tab)):
            tab[x] = tab[x] / 10
        return tab


    def fill_chart(table, index):
        tab = []
        for i in range(len(table)):
            tab.append(float(table[i][index]))
        return tab

    def fill_chart_species(table, index, species):
        tab = []
        for rows in table:
            if int(rows[4]) == species:
                tab.append(float(rows[index]))
        return tab

    quantity = 0
    setosa = 0
    versicolor = 0
    virginica = 0

    for row in data:
        quantity += 1
        if row[4] == '0':
            setosa += 1
        if row[4] == '1':
            versicolor += 1
        if row[4] == '2':
            virginica += 1

    setosaData = str(setosa) + " (" + str("{:.1f}".format(calculate_percentage(setosa, quantity))) + "%)"

    versicolorData = str(versicolor) + " (" + str("{:.1f}".format(calculate_percentage(versicolor, quantity))) + "%)"

    virginicaData = str(virginica) + " (" + str("{:.1f}".format(calculate_percentage(virginica, quantity))) + "%)"

    allPercentage = str(quantity) + " (" + str("{:.1f}".format(calculate_percentage(quantity))) + "%)"

data1 = {'Gatunek': ['setosa', 'versicolor', 'virginica', 'razem'],
         'Liczebnosc(%)': [setosaData.replace('.', ','), versicolorData.replace('.', ','),
                           virginicaData.replace('.', ','), allPercentage.replace('.', ',')]}

sr1 = str("{:.2f}".format(average(data, 0))) + " (" + str("{:.2f}".format(deviation(data, average(data, 0), 0))) + ")"
sr2 = str("{:.2f}".format(average(data, 1))) + " (" + str("{:.2f}".format(deviation(data, average(data, 1), 1))) + ")"
sr3 = str("{:.2f}".format(average(data, 2))) + " (" + str("{:.2f}".format(deviation(data, average(data, 2), 2))) + ")"
sr4 = str("{:.2f}".format(average(data, 3))) + " (" + str("{:.2f}".format(deviation(data, average(data, 3), 3))) + ")"

data2 = {'Cecha': ['Dlugosc dzialki kielicha (cm)', 'Szerokosc dzialki kielicha (cm)', 'Dlugosc platka (cm)',
                   'Szerokosc platka (cm)'],

         'Minimum': [str("{:.2f}".format(minimum(data, 0))).replace('.', ','),
                     str("{:.2f}".format(minimum(data, 1))).replace('.', ','),
                     str("{:.2f}".format(minimum(data, 2))).replace('.', ','),
                     str("{:.2f}".format(minimum(data, 3))).replace('.', ',')],

         'Sr. arytm. (± odch. stand.)': [sr1.replace('.', ','), sr2.replace('.', ','), sr3.replace('.', ','),
                                         sr4.replace('.', ',')],

         'Mediana (Q1 - Q3)': [str("{:.2f}".format(mediana(data, 0))).replace('.', ',') +
                               " (" + str("{:.2f}".format(Q1(data, 0))).replace('.', ',') +
                               " - " + str("{:.2f}".format(Q3(data, 0))).replace('.', ',') + ")",
                               str("{:.2f}".format(mediana(data, 1))).replace('.', ',') +
                               " (" + str("{:.2f}".format(Q1(data, 1))).replace('.', ',') +
                               " - " + str("{:.2f}".format(Q3(data, 1))).replace('.', ',') + ")",
                               str("{:.2f}".format(mediana(data, 2))).replace('.', ',') +
                               " (" + str("{:.2f}".format(Q1(data, 2))).replace('.', ',') +
                               " - " + str("{:.2f}".format(Q3(data, 2))).replace('.', ',') + ")",
                               str("{:.2f}".format(mediana(data, 3))).replace('.', ',') +
                               " (" + str("{:.2f}".format(Q1(data, 3))).replace('.', ',') +
                               " - " + str("{:.2f}".format(Q3(data, 3))).replace('.', ',') + ")"],

         'Maksimum': [str("{:.2f}".format(maksimum(data, 0))).replace('.', ','),
                      str("{:.2f}".format(maksimum(data, 1))).replace('.', ','),
                      str("{:.2f}".format(maksimum(data, 2))).replace('.', ','),
                      str("{:.2f}".format(maksimum(data, 3))).replace('.', ',')]}

#Histogram 1
chart1 = np.array(fill_chart(data, 0))
a = set_bins(4.0, 8.0, 0.5)
plt.hist(chart1, bins=a, edgecolor='black', linewidth=1.2)
plt.title('Długość działki kielicha')
plt.xlabel('Długość (cm)')
plt.ylabel('Liczebność')
axis = plt.gca()
axis.set_ylim([0, 35])
plt.show()

#Wykres pudelkowy 1
box_data1 = [fill_chart_species(data, 0, 0), fill_chart_species(data, 0, 1), fill_chart_species(data, 0, 2)]
plt.boxplot(box_data1)
plt.xticks([1, 2, 3], ["setosa", "versicolor", "virginica"])
plt.yticks(set_bins(4, 8, 1))
plt.ylabel("Długość (cm)")
plt.xlabel("Gatunek")
plt.grid()
plt.show()

#Histogram 2
chart2 = np.array(fill_chart(data, 1))
plt.hist(chart2, bins=set_bins(2.0, 4.5, 0.5), edgecolor='black', linewidth=1.2)
plt.title('Szerokość działki kielicha')
plt.xlabel('Szerokość (cm)')
plt.ylabel('Liczebność')
axis = plt.gca()
axis.set_ylim([0, 80])
plt.show()

#Wykres pudelkowy 2
box_data2 = [fill_chart_species(data, 1, 0), fill_chart_species(data, 1, 1), fill_chart_species(data, 1, 2)]
plt.boxplot(box_data2)
plt.xticks([1, 2, 3], ["setosa", "versicolor", "virginica"])
plt.yticks(set_bins(2.0, 5.0, 0.5))
plt.ylabel("Szerokość (cm)")
plt.xlabel("Gatunek")
plt.grid()
plt.show()

#Histogram 3
chart3 = np.array(fill_chart(data, 2))
plt.hist(chart3, bins=set_bins(1.0, 7.0, 0.5), edgecolor='black', linewidth=1.2)
plt.title('Długość płatka')
plt.xlabel('Długość (cm)')
plt.ylabel('Liczebność')
axis = plt.gca()
axis.set_ylim([0, 30])
plt.show()

#Wykres pudelkowy 3
box_data3 = [fill_chart_species(data, 2, 0), fill_chart_species(data, 2, 1), fill_chart_species(data, 2, 2)]
plt.boxplot(box_data3)
plt.xticks([1, 2, 3], ["setosa", "versicolor", "virginica"])
plt.yticks(set_bins(1, 7, 1))
plt.ylabel("Długość (cm)")
plt.xlabel("Gatunek")
plt.grid()
plt.show()

#Histogram 4
chart4 = np.array(fill_chart(data, 3))
plt.hist(chart4, bins=set_bins(0.1, 2.5, 0.1), edgecolor='black', linewidth=1.2)
plt.title('Szerokość płatka')
plt.xlabel('Szerokość (cm)')
plt.ylabel('Liczebność')
axis = plt.gca()
plt.xticks(set_bins(0.1, 2.5, 0.2))
axis.set_ylim([0, 30])
plt.show()

#Wykres pudelkowy 4
box_data4 = [fill_chart_species(data, 3, 0), fill_chart_species(data, 3, 1), fill_chart_species(data, 3, 2)]
plt.boxplot(box_data4)
plt.xticks([1, 2, 3], ["setosa", "versicolor", "virginica"])
plt.yticks(set_bins(0, 2.5, 0.5))
plt.ylabel("Szerokość (cm)")
plt.xlabel("Gatunek")
plt.grid()
plt.show()

#Tabele
df1 = pd.DataFrame(data1)
df2 = pd.DataFrame(data2)

#Wyswietlenie Tabel
#print(tabulate(df1, showindex=False, headers=df1.columns))
#print("\n")
#print(tabulate(df2, showindex=False, headers=df2.columns))

arr = np.array([3,2,1]);
arr1 = np.array([1,2,3]);
print(np.add(arr,arr1));
x = arr*2;
print(x);








