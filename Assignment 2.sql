--Sherwin Rahimi 2/2/2022--

--Setup for Databases AdventureWorks
USE AdventureWorks2019
GO

--Question 1 How many products can you find in the Production.Product table?--
SELECT COUNT(*) TheCount
FROM Production.Product

--Question 2  Write a query that retrieves the number of products in the Production.Product table that are included in a subcategory. The rows that have NULL in column ProductSubcategoryID are considered to not be a part of any subcategory. --
SELECT COUNT(*) TheCount
FROM Production.Product
WHERE ProductSubcategoryID IS NOT NULL

--Question 3 How many Products reside in each SubCategory? Write a query to display the results with the following titles. --
SELECT ProductSubcategoryID,COUNT(ProductSubcategoryID) CountedProducts
FROM Production.Product
GROUP BY ProductSubcategoryID

--Question 4 How many products that do not have a product subcategory. --
SELECT COUNT(*) TheCount
FROM Production.Product
WHERE ProductSubcategoryID IS NULL

--Question 5 Write a query to list the sum of products quantity in the Production.ProductInventory table.--
SELECT SUM(Quantity) TheSum
FROM Production.ProductInventory

--Question 6 Write a query to list the sum of products in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100. --
SELECT ProductID, SUM(Quantity) TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY ProductID
HAVING SUM(Quantity) < 100

--Question 7 Write a query to list the sum of products with the shelf information in the Production.ProductInventory table and LocationID set to 40 and limit the result to include just summarized quantities less than 100--
SELECT Shelf,ProductID, SUM(Quantity) TheSum
FROM Production.ProductInventory
WHERE LocationID = 40
GROUP BY Shelf,ProductID
HAVING SUM(Quantity) < 100

--Question 8 Write the query to list the average quantity for products where column LocationID has the value of 10 from the table Production.ProductInventory table. --
SELECT ProductID,AVG(Quantity) TheAVG
FROM Production.ProductInventory
WHERE LocationID = 10
GROUP BY ProductID

--Question 9 Write query  to see the average quantity  of  products by shelf  from the table Production.ProductInventory --
SELECT ProductID,Shelf,AVG(Quantity) TheAVG
FROM Production.ProductInventory
Group by ProductID,Shelf

--Question 10 Write query  to see the average quantity  of  products by shelf excluding rows that has the value of N/A in the column Shelf from the table Production.ProductInventory --
SELECT Shelf, AVG(Quantity) TheAVG
FROM Production.ProductInventory
WHERE Shelf <> 'N/A'
GROUP BY Shelf

--Question 11 List the members (rows) and average list price in the Production.Product table. This should be grouped independently over the Color and the Class column. Exclude the rows where Color or Class are null. --
SELECT Color,Class,COUNT(*)TheCount, AVG(ListPrice) AvgPrice
FROM Production.Product
WHERE Color IS NOT NULL AND Class IS NOT NULL
GROUP BY Color,Class

--Question 12 Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables. Join them and produce a result set similar to the following. --
SELECT pcr.CountryRegionCode Country, pcp.StateProvinceCode Province
FROM Person.CountryRegion pcr JOIN Person.StateProvince pcp ON pcr.CountryRegionCode = pcp.CountryRegionCode
ORDER BY pcr.CountryRegionCode,pcp.StateProvinceCode

--Question 13  Write a query that lists the country and province names from person. CountryRegion and person. StateProvince tables and list the countries filter them by Germany and Canada. Join them and produce a result set similar to the following.--
SELECT pcr.CountryRegionCode Country, pcp.StateProvinceCode Province
FROM Person.CountryRegion pcr JOIN Person.StateProvince pcp ON pcr.CountryRegionCode = pcp.CountryRegionCode
WHERE pcr.CountryRegionCode IN ('CA','DE')
ORDER BY pcr.CountryRegionCode,pcp.StateProvinceCode

--Using Northwnd Database: (Use aliases for all the Joins)--
USE Northwind
GO

--Question 14 List all Products that has been sold at least once in last 25 years. --
SELECT p.ProductName
FROM Products p JOIN [Order Details] o ON p.ProductID = o.ProductID JOIN [Orders] os ON o.OrderID = os.OrderID
WHERE YEAR(GETDATE())-YEAR(os.OrderDate) <=25
GROUP BY p.ProductName

--Question 15 List top 5 locations (Zip Code) where the products sold most. -- 
SELECT TOP 5 os.ShipPostalCode
FROM Products p JOIN [Order Details] o ON p.ProductID = o.ProductID JOIN [Orders] os ON o.OrderID = os.OrderID
WHERE os.ShipPostalCode IS NOT NULL
GROUP BY os.ShipPostalCode
ORDER BY COUNT(o.OrderID) DESC

--Question 16  List top 5 locations (Zip Code) where the products sold most in last 25 years. --
SELECT TOP 5 os.ShipPostalCode
FROM Products p JOIN [Order Details] o ON p.ProductID = o.ProductID JOIN [Orders] os ON o.OrderID = os.OrderID
WHERE os.ShipPostalCode IS NOT NULL AND YEAR(GETDATE())-YEAR(os.OrderDate) <=25
GROUP BY os.ShipPostalCode
ORDER BY COUNT(o.OrderID) DESC

--Question 17 List all city names and number of customers in that city. --
SELECT DISTINCT o.ShipCity, COUNT(c.CustomerID) NumOfCustomers
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY o.ShipCity

--Question 18 List city names which have more than 2 customers, and number of customers in that city --
SELECT DISTINCT o.ShipCity, COUNT(c.CustomerID) NumOfCustomers
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY o.ShipCity
HAVING COUNT(c.CustomerID) > 2

--Question 19 List the names of customers who placed orders after 1/1/98 with order date.
SELECT DISTINCT c.ContactName
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderDate > '19980101'

--Question 20 List the names of all customers with most recent order dates --
SELECT DISTINCT c.ContactName, MAX(o.OrderDate)
FROM Orders o JOIN Customers c ON o.CustomerID = c.CustomerID
GROUP BY c.ContactName

--Question 21 Display the names of all customers  along with the  count of products they bought
SELECT DISTINCT c.ContactName, SUM(od.Quantity) Quantity
FROM Customers c JOIN [Orders] o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.ContactName

--Question 22 Display the customer ids who bought more than 100 Products with count of products.
SELECT DISTINCT c.ContactName, SUM(od.Quantity) Quantity
FROM Customers c JOIN [Orders] o ON c.CustomerID = o.CustomerID JOIN [Order Details] od ON o.OrderID = od.OrderID
GROUP BY c.ContactName
HAVING SUM(od.Quantity) > 100

--Question 23 List all of the possible ways that suppliers can ship their products. Display the results as below
SELECT DISTINCT sup.CompanyName, ship.CompanyName
FROM Suppliers sup JOIN Products p ON sup.SupplierID = p.SupplierID JOIN [Order Details] od ON od.ProductID = p.ProductID JOIN [Orders] o ON O.OrderID = od.OrderID JOIN Shippers ship ON ship.ShipperID = o.ShipVia
ORDER BY sup.CompanyName,ship.CompanyName

--Question 24 Display the products order each day. Show Order date and Product Name. -- 
SELECT DISTINCT os.OrderDate,p.ProductName
FROM Products p JOIN [Order Details] o ON p.ProductID = o.ProductID JOIN [Orders] os ON o.OrderID = os.OrderID

--Question 25 Displays pairs of employees who have the same job title.
SELECT DISTINCT e1.FirstName + ' ' + e1.LastName EmployeeName, e2.FirstName + ' ' +e2.LastName Employee2Name
FROM Employees e1 JOIN Employees e2 ON e1.Title = e2.Title

--Question 26 Display all the Managers who have more than 2 employees reporting to them. --
SELECT e2.FirstName+ ' ' + e2.LastName Manager
FROM Employees e JOIN Employees e2 ON e.ReportsTo = e2.EmployeeID
GROUP BY e2.FirstName+ ' ' +e2.LastName
HAVING COUNT(e.EmployeeID) > 2

--Question 27  Display the customers and suppliers by city. The results should have the following columns--
SELECT DISTINCT City, CompanyName, ContactName, 'Supplier' [Type]
FROM Suppliers
UNION ALL
SELECT DISTINCT City, CompanyName, ContactName, 'Customer' [Type]
FROM Customers