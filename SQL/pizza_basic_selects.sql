--1-
SELECT pizza,price,country,base
FROM menu
ORDER BY pizza

--2-
SELECT pizza,price,country,base
FROM menu
ORDER BY price DESC,pizza

--3-
SELECT DISTINCT price 
from menu
ORDER BY price
--4-
SELECT pizza,price,country,base
from menu 
where price < 7 and country is not null

--5-
SELECT pizza,price,country,base
from menu 
where country != 'U.S.' and country != 'Italy' or country is NULL

--6-

