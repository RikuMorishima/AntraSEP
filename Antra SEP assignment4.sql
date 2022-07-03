Use Northwind;

-- 1. Create a view named Ågview_product_order_[your_last_name]Åh, list all products and total ordered quantity for that product.
DROP VIEW IF EXISTS view_product_order_morishima;
go
CREATE VIEW view_product_order_morishima AS
SELECT p.ProductName, sum(od.Quantity) [Total Ordered Quantity]
FROM Products p INNER JOIN [Order Details] od ON p.ProductID=od.ProductID
GROUP BY p.ProductName;
go
SELECT * FROM view_product_order_morishima;

-- 2. Create a stored procedure Ågsp_product_order_quantity_[your_last_name]Åh that accept product id as an input and total 
--    quantities of order as output parameter.
DROP PROCEDURE IF EXISTS sp_product_order_quantity_morishima;
go
CREATE PROCEDURE sp_product_order_quantity_morishima
@id int,
@quan int OUT
AS
BEGIN
	SELECT @quan = count(od.ProductID)
	FROM [Order Details] od
	WHERE od.ProductID=@id
END
go
BEGIN
DECLARE @qua int
EXEC sp_product_order_quantity_morishima 1, @qua OUT
PRINT @qua
END
-- 3. Create a stored procedure Ågsp_product_order_city_[your_last_name]Åh that accept product name as an input and top 5 cities 
--    that ordered most that product combined with the total quantity of that product ordered from that city as output.
DROP PROCEDURE IF EXISTS sp_product_order_quantity_morishima;
go
CREATE PROCEDURE sp_product_order_quantity_morishima
@id int,
@quan int OUT
AS
BEGIN
	SELECT @quan = count(od.ProductID)
	FROM [Order Details] od
	WHERE od.ProductID=@id
END
go
BEGIN
DECLARE @qua int
EXEC sp_product_order_quantity_morishima 1, @qua OUT
PRINT @qua
END


-- 4. Create 2 new tables Ågpeople_your_last_nameÅh Ågcity_your_last_nameÅh. City table has two records: {Id:1, City: Seattle}, 
--    {Id:2, City: Green Bay}. People has three records: {id:1, Name: Aaron Rodgers, City: 2}, {id:2, Name: Russell Wilson, City:1}, 
--    {Id: 3, Name: Jody Nelson, City:2}. Remove city of Seattle. If there was anyone from Seattle, put them into a new city ÅgMadisonÅh. 
--    Create a view ÅgPackers_your_nameÅh lists all people from Green Bay. If any error occurred, no changes should be made to DB. 
--    (after test) Drop both tables and view.
DROP TABLE IF EXISTS city_morishima;
go
CREATE TABLE city_morishima (
id int primary key,
City varchar(30)
);

DROP TABLE IF EXISTS people_morishima;
go
CREATE TABLE people_morishima (
id int primary key,
Name varchar(30),
City int foreign key references city_morishima(id) on delete set null
);

INSERT city_morishima values
(1, 'Seattle'),
(2, 'Green Bay');

INSERT people_morishima values
(1, 'Aaron Rodgers', 2),
(2, 'Russell Wilson', 1),
(3, 'Jody Nelson', 2);

DECLARE @deletedID int;
SELECT @deletedID=id FROM city_morishima WHERE City='Seattle';
DELETE FROM dbo.city_morishima WHERE City='Seattle';
INSERT city_morishima values (3,'Madison');

UPDATE people_morishima
SET City=3
WHERE City=@deletedID;

go

DROP VIEW IF EXISTS Packers_morishima;
go
CREATE VIEW Packers_morishima
AS 
	SELECT p.Name 
	FROM people_morishima p INNER JOIN city_morishima c ON p.City=c.id
	WHERE c.City='Green Bay'
go
SELECT * FROM Packers_morishima;
go


DROP TABLE IF EXISTS people_morishima;
go
DROP TABLE IF EXISTS city_morishima;
go
DROP VIEW IF EXISTS Packers_morishima;
go

-- 5. Create a stored procedure Ågsp_birthday_employees_[you_last_name]Åh that creates a new table Ågbirthday_employees_your_last_nameÅh 
--    and fill it with all employees that have a birthday on Feb. (Make a screen shot) drop the table. Employee table should not be affected.
DROP PROCEDURE IF EXISTS sp_birthday_employees_morishima;
go
CREATE PROCEDURE sp_birthday_employees_morishima
AS BEGIN
	DROP TABLE IF EXISTS birthday_employees_morishima;
	CREATE TABLE birthday_employees_morishima (
		Name varchar(30)
	)
	INSERT INTO birthday_employees_morishima
	SELECT e.FirstName + ' ' + e.LastName FROM Employees e WHERE MONTH(e.BirthDate)=2;

	SELECT * FROM birthday_employees_morishima;
		DROP TABLE IF EXISTS birthday_employees_morishima;
END

-- 6. How do you make sure two tables have the same data?
/*
	We can make sure if two tables have the same data by checking if data returns any data
	when inner joining the two tables with all of the columns. For example,
	a INNER JOIN b on a.id=b.id AND a.name=b.name AND ... AND a.city=b.city
	
	We can check if there is a row within a select statement by using the EXISTS keyword.
*/