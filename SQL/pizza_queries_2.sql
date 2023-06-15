--1.1--
SELECT COUNT(pizza) AS Total_pizzas
FROM dbo.menu 

--1.2--
SELECT COUNT(distinct country) AS Origins
FROM dbo.menu WHERE country IS NOT NULL 

--1.3--
SELECT MIN(price) AS Cheapest_Italian
FROM dbo.menu WHERE country = 'Italy'

--1.4--
SELECT SUM(price) AS Margherita_Vegetarian
FROM dbo.menu WHERE pizza = 'margherita' OR pizza = 'vegetarian'


--1.5--
SELECT MIN(price) AS MIN_PRICE, MAX(price) AS MAX_PRICE, AVG(price)  AS AVG_PRICE
FROM dbo.menu

--1.6--
SELECT COUNT(pizza) AS  "no of wheat mix"
FROM dbo.menu WHERE base = 'wholemeal'

--1.7--
SELECT COUNT(pizza) AS no_origin
FROM dbo.menu WHERE country IS NULL 

--1.8--
SELECT CONVERT(DECIMAL(10,2),AVG(0.3*50*price)) AS profit
FROM dbo.menu 


--2.1--
SELECT ITEMS.ingredient, ITEMS."type"
FROM ITEMS inner Join RECIPES
ON ITEMS.ingredient = RECIPES.ingredient  
WHERE RECIPES.pizza = 'margherita'

--2.2--
SELECT RECIPES.ingredient, RECIPES.pizza
FROM RECIPES inner Join ITEMS
ON RECIPES.ingredient = ITEMS.ingredient  
WHERE ITEMS."type" = 'fish'

--2.3--
SELECT RECIPES.ingredient, RECIPES.pizza
FROM RECIPES inner Join ITEMS
ON RECIPES.ingredient = ITEMS.ingredient  
WHERE ITEMS."type" = 'meat'

--2.4--
SELECT m1.pizza
from menu m1
JOIN menu m2 ON m1.country = m2.country
WHERE m2.pizza = 'siciliano' and m1.pizza != 'siciliano'

--2.5--
SELECT DISTINCT m1.pizza
from menu m1
JOIN menu m2 ON m1.price > m2.price
WHERE m2.pizza > 'quattro stagioni' and m1.pizza != 'quattro stagioni'


--2.6--
SELECT ITEMS.ingredient, RECIPES.pizza
FROM RECIPES RIGHT Join ITEMS
ON RECIPES.ingredient = ITEMS.ingredient  
WHERE ITEMS."type" = 'fish'

--2.7--
SELECT DISTINCT ITEMS.type	
FROM ITEMS
inner Join RECIPES
ON RECIPES.ingredient=ITEMS.ingredient
inner join MENU
ON RECIPES.pizza=MENU.pizza
WHERE MENU.country = 'U.S.' or MENU.country = 'Canada' or MENU.country = 'Mexico'

--2.8--
SELECT RECIPES.pizza
FROM RECIPES 
inner join ITEMS
ON RECIPES.ingredient=ITEMS.ingredient
inner join MENU
ON RECIPES.pizza=MENU.pizza
WHERE ITEMS."type" ='fruit' AND MENU.base = 'wholemeal'


