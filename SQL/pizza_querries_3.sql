USE pizza;

--1
SELECT country,AVG(price) AS avg_price
FROM menu
GROUP BY country
HAVING country IS NOT NULL

--2
SELECT country,MAX(price) AS max_price
FROM menu
GROUP BY country
HAVING country IS NOT NULL

--3
SELECT country,MIN(price) AS min_price
FROM menu
GROUP BY country
HAVING country IS NOT NULL

--4
SELECT country,AVG(price) AS avg_price
FROM menu
GROUP BY country
HAVING count(country) > 1

--5
SELECT country,AVG(price) AS avg_price
FROM menu
WHERE country like '%i%'
GROUP BY country



--6
SELECT country,MIN(price) AS min_price
FROM menu
WHERE price < 7.50 
GROUP BY country
HAVING country IS NOT NULL


--CZESC 2

--1
SELECT pizza,price
FROM menu
WHERE price > (SELECT MAX(price) 
				FROM menu 
				WHERE country = 'Italy')


--2
SELECT DISTINCT pizza
FROM recipes
WHERE ingredient IN (SELECT ingredient 
				FROM items 
				WHERE type = 'meat')

--3 b³¹d
SELECT ingredient, pizza, amount 
from recipes
WHERE amount IN (SELECT MAX(amount) from recipes
group by amount)
GROUP by ingredient,pizza,amount
ORDER by ingredient desc




--4 nie wiem czy skolerowane czy nie
SELECT Tabela.ingredient
FROM(SELECT RECIPES.ingredient,COUNT(Recipes.ingredient) AS liczba
FROM RECIPES
GROUP BY recipes.ingredient
HAVING COUNT(Recipes.ingredient)>1)AS Tabela 

--5
SELECT MENU.pizza
FROM MENU
WHERE MENU.country = (SELECT MENU.country FROM MENU WHERE MENU.pizza ='siciliano') and MENU.pizza != 'siciliano'

--2.6
SELECT Tabela.ingredient
FROM	(SELECT ITEMS.ingredient, RECIPES.pizza
		FROM RECIPES RIGHT Join ITEMS
		ON RECIPES.ingredient = ITEMS.ingredient  
		WHERE RECIPES.pizza is null)
as Tabela

--2.7 
Select Distinct Tabela1.ingredient
FROM RECIPES AS Tabela1
WHERE(SELECT COUNT(Tabela2.ingredient)FROM RECIPES AS Tabela2
WHERE Tabela2.ingredient = Tabela1.ingredient)>1

--2.8
SELECT MENU.PIZZA, MENU.price
FROM MENU
WHERE MENU.price >  (SELECT MENU.price
					 FROM MENU WHERE Menu.pizza='garlic') 
					 AND MENU.price <
					(SELECT MENU.price
					 FROM MENU WHERE Menu.pizza='napoletana')


--9
SELECT TOP 1 Tabela.pizza
FROM (SELECT RECIPES.pizza,COUNT(Recipes.pizza) AS liczba
FROM RECIPES
GROUP BY recipes.pizza)AS Tabela
ORDER BY Tabela.liczba DESC


--10
SELECT DISTINCT Items."Type"
FROM ITEMS
inner Join RECIPES
ON RECIPES.ingredient=ITEMS.ingredient
inner join MENU
ON RECIPES.pizza=MENU.pizza
WHERE MENU.pizza=(SELECT TOP 1 Tabela.pizza
FROM(SELECT MENU.pizza,MAX(MENU.price)AS price
FROM MENU
Group BY Menu.price,Menu.pizza) AS Tabela
ORDER BY Tabela.price DESC)

