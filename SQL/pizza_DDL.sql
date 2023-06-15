CREATE DATABASE pizza;

USE pizza;

CREATE TABLE items(
	ingredient varchar(20) CONSTRAINT items_PK PRIMARY KEY,
	type varchar(12)
	);

	CREATE TABLE menu(
	pizza varchar(20) CONSTRAINT menu_PK PRIMARY KEY,
	price float,
	country varchar(10),
	base varchar(15)
	);

	CREATE TABLE recipes(
	pizza varchar(20) REFERENCES menu(pizza),
	ingredient varchar(20) REFERENCES items(ingredient),
	amount int,
	PRIMARY KEY(pizza,ingredient)
	);
