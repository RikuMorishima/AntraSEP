Use Northwind;

-- 1. List all cities that have both Employees and Customers
SELECT DISTINCT e.City
FROM Employees e 
WHERE e.City in (SELECT City FROM Customers);

-- 2. List all cities that have Customers but no Employee
    -- a. use subquery
SELECT DISTINCT c.City
FROM Customers c
WHERE c.City NOT IN (SELECT e.City FROM Employees e);

	-- b. not using subquery
SELECT DISTINCT c.City
FROM Customers c LEFT JOIN Employees e ON c.City=e.City
WHERE e.City IS NULL;

-- 3. List all products and their total order quantities throughout all orders.
SELECT p.ProductName, SUM(od.Quantity) [Total Order quantity]
FROM Products p INNER JOIN [Order Details] od ON p.ProductID=od.ProductID
GROUP BY p.ProductName
ORDER BY [Total Order quantity] DESC;

-- 4. List all Customer Cities and total products ordered by that city.
-- (assume total amount of products ordered by the city)
SELECT c.City, sum (od.Quantity) [Total Ordered]
FROM Customers c LEFT JOIN  Orders o ON c.CustomerID=o.CustomerID
				 LEFT JOIN  [Order Details] od ON o.OrderID=od.OrderID  -- left join here to accomodate customer cities that did not order anything
GROUP BY c.City
ORDER BY [Total Ordered] DESC;

-- 5. List all Customer Cities that have at least two customers
    -- a. use union
SELECT c1.City
FROM Customers c1
EXCEPT 
SELECT c2.City
FROM Customers c2
GROUP BY c2.City
HAVING count(*)=1
UNION 
SELECT c3.City
FROM Customers c3
GROUP BY c3.City
HAVING count(*)=0;  -- union with an empty table

	-- b. use subquery and no union
SELECT c.City
FROM (
	SELECT City FROM Customers
) c
GROUP BY c.City
HAVING count(*) >=2

-- 6. List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.City, count(od.ProductID)
FROM Customers c INNER JOIN Orders o ON c.CustomerID=o.CustomerID
				 INNER JOIN [Order Details] od ON o.OrderID=od.OrderID
GROUP BY c.City
HAVING count(DISTINCT od.ProductID) >= 2
ORDER BY count(od.ProductID) DESC;

-- 7. List all Customers who have ordered products, but have the eship cityf on the order different from their own customer cities.
SELECT DISTINCT c.CustomerID, c.CompanyName
FROM Customers c INNER JOIN Orders o ON c.CustomerID=o.CustomerID
WHERE c.City!=o.ShipCity;

-- 8. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.
select a.ProductName, a.[average price], a.[sum], b.City
FROM 
(SELECT TOP 5 p.ProductName, avg(od.UnitPrice) [average price], sum(od.Quantity) [sum], Row_Number() Over (Order by sum(od.Quantity) DESC) [RANK] 
FROM Products p INNER JOIN [Order Details] od ON p.ProductID=od.ProductID
				INNER JOIN Orders o ON od.OrderID=o.OrderID
				INNER JOIN Customers c ON o.CustomerID=c.CustomerID
GROUP BY p.ProductName
ORDER BY [sum] DESC ) a INNER JOIN 
(SELECT TOP 5 p1.ProductName, c1.City,Row_Number() Over (Order by sum(od1.Quantity) DESC) [RANK] 
	  FROM Customers c1 INNER JOIN Orders o1 ON o1.CustomerID=c1.CustomerID
						INNER JOIN [Order Details] od1 ON od1.OrderID=o1.OrderID
						INNER JOIN Products p1 ON p1.ProductID=od1.ProductID
	  GROUP BY c1.City, p1.ProductName
	  ORDER BY sum(od1.Quantity) DESC
	 ) b ON a.RANK = b.RANK
;

-- 9. List all cities that have never ordered something but we have employees there.
    -- a. use subquery
SELECT DISTINCT e.City
FROM Employees e
WHERE e.City not IN (
	SELECT c.City FROM Customers c LEFT JOIN Orders o ON c.CustomerID=o.CustomerID WHERE o.CustomerID IS NOT NULL  -- Cities that have an order
	);


	-- b. not using subquery
SELECT DISTINCT e.City
FROM Customers c
				 LEFT JOIN Orders o ON c.CustomerID=o.CustomerID
				 RIGHT JOIN Employees e ON c.City=e.City
WHERE o.CustomerID IS NULL OR c.City IS NULL;

--10. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, 
--    and also the city of most total quantity of products ordered from. (tip: join  sub-query)
SELECT TOP 1 c.City, count(o.OrderID) [Total Order Count]
FROM Customers c INNER JOIN Orders o ON c.CustomerID=o.CustomerID
GROUP BY c.City
ORDER BY count(DISTINCT o.OrderID) desc

SELECT TOP 1 c.City, D.[Sum]
FROM Customers c INNER JOIN (
	SELECT o.CustomerID, sum(od.Quantity) [Sum]
	FROM Orders o INNER JOIN  [Order Details] od ON o.OrderID=od.OrderID
	GROUP BY o.CustomerID
) d ON c.CustomerID=d.CustomerID
ORDER BY d.[Sum] DESC;
--11. How do you remove the duplicates record of a table?
/*
	We can first find the duplicate values by using GROUP BY with every column within the table, and 
	using HAVING COUNT(column) > 1. By doing this, we can get duplicate rows.

	We then can delete the records then input a single record per originally duplicate rows.
*/