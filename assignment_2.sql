-- 1. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the
-- following.
USE AdventureWorks2019;
GO

SELECT pcr.Name AS Country, psp.Name AS Province
FROM Person.CountryRegion pcr JOIN Person.StateProvince psp ON pcr.CountryRegionCode = psp.CountryRegionCode


    -- Country                        Province



-- 2. Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada.
-- Join them and produce a result set similar to the following.

SELECT pcr.Name AS Country, psp.Name AS Province
FROM Person.CountryRegion pcr JOIN Person.StateProvince psp ON pcr.CountryRegionCode = psp.CountryRegionCode
WHERE pcr.Name IN ('Germany', 'Canada')


    -- Country                        Province


--  Using Northwind Database: (Use aliases for all the Joins)

Use Northwind
GO

-- 3. List all Products that has been sold at least once in last 25 years.
SELECT oo.OrderDate, ProductID, COUNT(od.Quantity) as Quantity 
FROM dbo.[Order Details] od JOIN dbo.Orders oo ON od.OrderID = oo.OrderID
WHERE YEAR(CURRENT_TIMESTAMP) - YEAR(oo.OrderDate) < 25 AND od.Quantity >= 1
GROUP BY oo.OrderDate, ProductID


-- 4. List top 5 locations (Zip Code) where the products sold most in last 25 years.
SELECT TOP 5 ShipPostalCode, COUNT(od.Quantity) as Quantity
FROM dbo.[Order Details] od JOIN dbo.Orders oo ON od.OrderID = oo.OrderID
WHERE YEAR(CURRENT_TIMESTAMP) - YEAR(oo.OrderDate) < 25 
GROUP BY ShipPostalCode
ORDER BY Quantity DESC


-- 5. List all city names and number of customers in that city.     
SELECT City, COUNT(CustomerID) AS [Number of Customers]
FROM dbo.Customers
GROUP BY City



-- 6. List city names which have more than 2 customers, and number of customers in that city
SELECT City, COUNT(CustomerID) AS [Number of Customers]
FROM dbo.Customers
GROUP BY City
HAVING COUNT(CustomerID) > 2



-- 7. Display the names of all customers  along with the  count of products they bought
SELECT c.CustomerID, COUNT(od.ProductID)
FROM dbo.Products p JOIN dbo.[Order Details] od ON p.ProductID = od.ProductID JOIN dbo.Orders o ON o.OrderID=od.OrderID JOIN dbo.Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID


-- 8. Display the customer ids who bought more than 100 Products with count of products.

SELECT c.CustomerID, COUNT(od.ProductID)
FROM dbo.Products p JOIN dbo.[Order Details] od ON p.ProductID = od.ProductID JOIN dbo.Orders o ON o.OrderID=od.OrderID JOIN dbo.Customers c ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID
HAVING COUNT(od.ProductID) > 100


-- 9. List all of the possible ways that suppliers can ship their products. Display the results as below

 -- do not know how to write


    -- Supplier Company Name                Shipping Company Name
    ---------------------------------            ----------------------------------


-- 10. Display the products order each day. Show Order date and Product Name.

SELECT o.OrderDate AS [Order Date], p.ProductName AS [Product Name] 
FROM dbo.Orders o JOIN dbo.[Order Details] d ON o.OrderID=d.OrderID JOIN Products p on d.ProductID = p.ProductID

-- 11. Displays pairs of employees who have the same job title.
SELECT * 
FROM dbo.Employees

-- 12. Display all the Managers who have more than 2 employees reporting to them.
SELECT COUNT(e.EmployeeID) as EmployeeNumber, m.EmployeeID as ManagerID
FROM dbo.Employees e LEFT JOIN dbo.Employees m ON e.ReportsTo = m.EmployeeID 
GROUP BY m.EmployeeID
HAVING COUNT(e.EmployeeID) > 2

-- 13. Display the customers and suppliers by city. The results should have the following columns
-- City


-- Name


-- Contact Name,


-- Type (Customer or Supplier)

-- All scenarios are based on Database NORTHWIND.

-- 14. List all cities that have both Employees and Customers.
SELECT DISTINCT City
FROM Customers
WHERE City IN 
(SELECT City FROM Employees)
-- 15. List all cities that have Customers but no Employee.

-- a. 
    
--  Use
-- sub-query

SELECT DISTINCT City
FROM Customers
WHERE City NOT IN 
(SELECT City FROM Employees)

-- b. 
    
--  Do
-- not use sub-query

SELECT c.City
FROM Customers c LEFT JOIN Employees e ON c.City = e.City
WHERE c.City IS NULL

-- 16. List all products and their total order quantities throughout all orders.

SELECT p.ProductID, COUNT(Quantity)
FROM Products p JOIN [Order Details] od ON p.ProductID = od.ProductID
GROUP BY p.ProductID

-- 17. List all Customer Cities that have at least two customers.


-- a. 
    
--  Use
-- union


-- b. 
    
--  Use
-- no union
SELECT City, COUNT(CustomerID)
FROM Customers 
GROUP BY City
HAVING COUNT(CustomerID) > 2

-- 18. List all Customer Cities that have ordered at least two different kinds of products.
SELECT c.City, COUNT(DISTINCT(ProductID))
FROM Orders o JOIN Customers c ON o.CustomerID=c.CustomerID JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.City
HAVING COUNT(DISTINCT(ProductID)) > 2


-- 19. List 5 most popular products, their average price, and the customer city that ordered most quantity of it.

SELECT  RANK() OVER (ORDER BY COUNT(od.Quantity)),c.City
FROM Orders o JOIN Customers c ON o.CustomerID=c.CustomerID JOIN [Order Details] od ON od.OrderID = o.OrderID
GROUP BY c.City

-- 20. List one city, if exists, that is the city from where the employee sold most orders (not the product quantity) is, and also the city of most total quantity of products ordered
-- from. (tip: join  sub-query)

SELECT Top 1 c.City,  RANK() OVER (ORDER BY COUNT(o.OrderID) DESC), COUNT(o.OrderID) AS TotalOrder
FROM Orders o JOIN Customers c ON o.CustomerID=c.CustomerID 
GROUP BY c.City


-- 21. How do you remove the duplicates record of a table?
use CTE with ROW_NUMBER function to delete duplicate rows when calculated row number is larger than 1