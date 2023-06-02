import numpy as np
from matplotlib import pyplot as plt
import csv


with open("./data.csv", 'r') as file:
    csvreader = csv.reader(file)
    data = list(csvreader)

    def fill_chart(index, table=data):
        tab = []
        for i in range(len(table)):
            tab.append(float(table[i][index]))
        return tab


    def average(index, table=data):
        counter = 0
        sum = 0
        for elements in range(len(table)):
            counter += 1
            sum += float(table[elements][index])
        return sum / counter


    def p_corr(avgx, avgy, indexx, indexy, table=data):
        sum1 = 0
        sum2 = 0
        sum3 = 0
        for i in range(len(table)):
            sum1 += (float(table[i][indexx]) - float(avgx)) * (float(table[i][indexy]) - float(avgy))
            sum2 += (float(table[i][indexx]) - float(avgx)) * (float(table[i][indexx]) - float(avgx))
            sum3 += (float(table[i][indexy]) - float(avgy)) * (float(table[i][indexy]) - float(avgy))

        return sum1 / (np.sqrt(sum2) * np.sqrt(sum3))

    def b0(indexx, indexy, table=data):
        sum1 = 0
        sum2 = 0
        sum3 = 0
        sum4 = 0
        n = len(table)
        for i in range(len(table)):
            sum1 += float(table[i][indexy])

            sum2 += float(table[i][indexx]) ** 2

            sum3 += float(table[i][indexx])

            sum4 += float(table[i][indexx]) * float(table[i][indexy])

        return (sum1 * sum2 - sum3 * sum4) / (n * sum2 - sum3 * sum3)


    def b1(indexx, indexy, table=data):
        sum1 = 0
        sum2 = 0
        sum3 = 0
        sum4 = 0
        n = len(table)
        for i in range(len(table)):
            sum1 += float(table[i][indexx]) * float(table[i][indexy])
            sum2 += float(table[i][indexx])
            sum3 += float(table[i][indexy])
            sum4 += float(table[i][indexx]) * float(table[i][indexx])
        return (n * sum1 - sum2 * sum3) / (n * sum4 - sum2 * sum2)



    def draw_plot(indexx, indexy, xaxis, yaxis):
        x = np.array(fill_chart(indexx))
        y = np.array(fill_chart(indexy))
        r = "{:.2f}".format(p_corr(average(indexx), average(indexy), indexx, indexy))
        b_1 = "{:.1f}".format(b1(indexx, indexy))
        b_0 = "{:.1f}".format(b0(indexx, indexy))
        plt.scatter(x, y)
        if float(b_0) > 0:
            plt.title("r = " + str(r) + "; y = " + str(b_1) + "x + " + str(b_0))
        else:
            plt.title("r = " + str(r) + "; y = " + str(b_1) + "x " + str(b_0))

        plt.plot(x, float(b_1)*x+float(b_0), color="red")
        plt.xlabel(f'{xaxis} (cm)')
        plt.ylabel(f'{yaxis} (cm)')
        plt.show()

r1 = "{:.2f}".format(p_corr(average(0), average(1), 0, 1))

r2 = "{:.2f}".format(p_corr(average(0), average(2), 0, 2))

r3 = "{:.2f}".format(p_corr(average(0), average(3), 0, 3))

r4 = "{:.2f}".format(p_corr(average(1), average(2), 1, 2))

r5 = "{:.2f}".format(p_corr(average(1), average(3), 1, 3))

r6 = "{:.2f}".format(p_corr(average(2), average(3), 2, 3))

draw_plot(0, 1, "Długość działki kielicha", "Szerokość działki kielicha")
draw_plot(0, 2, "Długość działki kielicha", "Długość płatka")
draw_plot(0, 3, "Długość działki kielicha", "Szerokość płatka")
draw_plot(1, 2, "Szerokość działki kielicha", "Długość płatka")
draw_plot(1, 3, "Szerokość działki kielicha", "Szerokość płatka")
draw_plot(2, 3, "Długość płatka", "Szerokość płatka")








