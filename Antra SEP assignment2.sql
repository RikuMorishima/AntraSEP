Use AdventureWorks2019;
--  1. How many products can you find in the Production.Product table?
SELECT count(p.ProductID) [Number of Products]
FROM Production.Product p;

--  2. Write a query that retrieves the number of products in the Production.Product table 
--     that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID 
--     are considered to not be a part of any subcategory.
SELECT count(p.ProductSubcategoryID)
FROM Production.Product p 
WHERE p.ProductSubcategoryID IS NOT NULL;

--  3. How many Products reside in each SubCategory? Write a query to display the results with the following titles. (titles omitted)
SELECT p.ProductSubcategoryID, count(p.ProductID) [CountedProducts]
FROM Production.Product p
GROUP BY p.ProductSubcategoryID;

--  4. How many products that do not have a product subcategory.
SELECT count(p.ProductID) [Number Of Products that do not have a subcategory]
FROM Production.Product p 
WHERE p.ProductSubcategoryID IS NULL;

--  5. Write a query to list the sum of products quantity in the Production.ProductInventory table.
SELECT sum(i.Quantity) [Sum of Productions quantity]
FROM Production.ProductInventory i;

--  6. Write a query to list the sum of products in the Production.ProductInventory table and 
--     LocationID set to 40 and limit the result to include just summarized quantities less than 100. (titles omitted)
SELECT i.ProductID, sum(i.Quantity) [TheSum]
FROM Production.ProductInventory i
WHERE i.LocationID=40
GROUP BY i.ProductID
HAVING sum(i.Quantity) < 100;

--  7. Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and
--     LocationID set to 40 and limit the result to include just summarized quantities less than 100 (titles omitted)
--SELECT * FROM Production.ProductInventory;
SELECT i.Shelf, i.ProductID, sum(i.Quantity) [TheSum]
FROM Production.ProductInventory i
WHERE i.LocationID=40
GROUP BY i.Shelf, i.ProductID
HAVING sum(i.Quantity) < 100;

--  8. Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table.
SELECT AVG(i.Quantity) [TheSum]
FROM Production.ProductInventory i
WHERE i.LocationID=10;

--  9. Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory
SELECT i.ProductID, i.Shelf, avg(i.Quantity) [TheAvg]
FROM Production.ProductInventory i
GROUP BY i.Shelf, i.ProductID;

-- 10. Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in 
--     the column Shelf from the table Production.ProductInventory
SELECT i.ProductID, i.Shelf, avg(i.Quantity) [TheAvg]
FROM Production.ProductInventory i
WHERE i.Shelf!='N/A'
GROUP BY i.Shelf, i.ProductID;

-- 11. List the members (rows) and average list price in the Production.Product table. 
--    This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null.
SELECT p.Color, p.Class, count(p.ProductID)[TheCount], avg(p.ListPrice)[AvgPrice]
FROM Production.Product p
WHERE p.Class IS NOT NULL AND p.Color IS NOT NULL
GROUP BY p.Color, p.Class;

---------
--Joins--
---------

-- 12. Write a query that lists the country and province names from person.CountryRegion 
--     and person.StateProvince tables. Join them and produce a result set similar to the following. (titles omitted)
SELECT cr.Name [Country], sp.Name [Province]
FROM Person.CountryRegion cr INNER JOIN Person.StateProvince sp ON cr.CountryRegionCode=sp.CountryRegionCode;

-- 13. Write a query that lists the country and province names from person. CountryRegion and person. 
--     StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.
SELECT cr.Name [Country], sp.Name [Province]
FROM Person.CountryRegion cr INNER JOIN Person.StateProvince sp ON cr.CountryRegionCode=sp.CountryRegionCode
WHERE cr.Name='Germany' OR cr.Name='Canada';


 Use Northwind;

 -- 14. List all Products that has been sold at least once in last 25 years.
 SELECT *
 FROM Products p INNER JOIN [Order Details] od ON p.ProductID=od.ProductID
				 INNER JOIN Orders o ON od.OrderID=o.OrderID
 WHERE DATEDIFF(year, getDate(),o.OrderDate) <= 25;

 -- 15. List top 5 locations (Zip Code) where the products sold most.
 SELECT TOP 5 o.ShipPostalCode, sum(od.Quantity) [Number Sold]
 FROM [Order Details] od INNER JOIN Orders o ON od.OrderID=o.OrderID
 GROUP BY o.ShipPostalCode
 HAVING o.ShipPostalCode IS NOT NULL
 ORDER BY [Number Sold] DESC;

 -- 16. List top 5 locations (Zip Code) where the products sold most in last 25 years.
 SELECT TOP 5 o.ShipPostalCode, sum(od.Quantity) [Number Sold]
 FROM Products p INNER JOIN [Order Details] od ON p.ProductID=od.ProductID
				 INNER JOIN Orders o ON od.OrderID=o.OrderID
 WHERE DATEDIFF(year, getDate(),o.OrderDate) <= 25
 GROUP BY o.ShipPostalCode
 HAVING o.ShipPostalCode IS NOT NULL
 ORDER BY [Number Sold] DESC;

 -- 17. List all city names and number of customers in that city.     
 SELECT c.City, count(c.City) [Number of Customers]
 FROM Customers c
 GROUP BY c.City
 ORDER BY [Number of Customers] DESC;

 -- 18. List city names which have more than 2 customers, and number of customers in that city
  SELECT c.City, count(c.City) [Number of Customers]
 FROM Customers c
 GROUP BY c.City
 HAVING count(c.City) >= 2
 ORDER BY [Number of Customers] DESC;

 -- 19. List the names of customers who placed orders after 1/1/98 with order date.
 SELECT DISTINCT c.ContactName
 FROM Customers c INNER JOIN Orders o ON c.CustomerID=o.CustomerID
 WHERE DATEDIFF(year, CAST('19980101 00:00:00.000' AS DATETIME),o.OrderDate) >= 0;

 -- 20. List the names of all customers with most recent order dates
 SELECT DISTINCT TOP 5 PERCENT  c.ContactName
 FROM Customers c INNER JOIN Orders o ON c.CustomerID=o.CustomerID;

 -- 21. Display the names of all customers along with the count of products they bought
 SELECT c.ContactName, count(od.productID) [Number of Products bought]
 FROM Customers c INNER JOIN Orders o ON c.CustomerID=o.CustomerID
				  INNER JOIN [Order Details] od ON o.OrderID=od.OrderID
 GROUP BY c.ContactName
 ORDER BY [Number of Products bought] DESC;

 -- 22. Display the customer ids who bought more than 100 Products with count of products.
 SELECT c.CustomerID, count(od.ProductID) [Number of Products bought]
 FROM Customers c INNER JOIN Orders o ON c.CustomerID=o.CustomerID
				  INNER JOIN [Order Details] od ON o.OrderID=od.OrderID
 GROUP BY c.CustomerID
 HAVING count(od.ProductID)>=100
 ORDER BY [Number of Products bought] DESC;

 -- 23. List all of the possible ways that suppliers can ship their products. Display the results as below (title omitted)
 SELECT DISTINCT s.CompanyName [Supplier Company Name], c.CompanyName [Shipping Company Name]
 FROM Customers c INNER JOIN Orders o ON c.CustomerID=o.CustomerID
				  INNER JOIN [Order Details] od ON o.OrderID=od.OrderID
				  INNER JOIN Products p ON od.ProductID=p.ProductID
				  INNER JOIN Suppliers s ON p.SupplierID=s.SupplierID;

 -- 24. Display the products order each day. Show Order date and Product Name.
 SELECT p.ProductName, o.OrderDate
 FROM Orders o INNER JOIN [Order Details] od ON o.OrderID=od.OrderID
			   INNER JOIN Products p ON od.ProductID=p.ProductID
 ORDER BY o.OrderDate;

 -- 25. Displays pairs of employees who have the same job title.
SELECT DISTINCT e1.FirstName + ' ' + e1.LastName [Full name 1], e2.FirstName + ' ' + e2.LastName [Full name 2]
FROM Employees e1 CROSS JOIN Employees e2
WHERE e1.Title=e2.Title AND e1.EmployeeID!=e2.EmployeeID;


 -- 26. Display all the Managers who have more than 2 employees reporting to them.
 WITH countManagers AS (
SELECT count(e.EmployeeID) [count], e2.ReportsTo
FROM Employees e INNER JOIN Employees e2 ON e.EmployeeID=e2.ReportsTo
GROUP BY e2.ReportsTo
HAVING count(e.EmployeeID) > 2
) 
SELECT e.FirstName + ' ' + e.LastName [Full Name]
FROM Employees e RIGHT JOIN countManagers c ON c.ReportsTo=e.EmployeeID;

 -- 27. Display the customers and suppliers by city. The results should have the following columns (columns ommited)
SELECT csc.City, csc.CompanyName [Name], csc.ContactName, csc.Relationship [Type]
FROM [Customer and Suppliers by City] csc;