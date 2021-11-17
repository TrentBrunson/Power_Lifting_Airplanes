select * from Addresses

select * from Administrators

select * from Categories

select * from Customers

select * from OrderItems

select * from Orders

select * from Products

SELECT MAX(ListPrice) as [Highest List Price], MIN(ListPrice) [Lowest List Price]
  FROM Products;

SELECT SUM((ItemPrice * Quantity) - DiscountAmount)
 FROM OrderItems;

SELECT COUNT(CustomerID) AS [# cust],
   MIN (LastName + ', ' + FirstName) as [1st cust] ,
   MAX (LastName + ', ' + FirstName) as [last cust]
 FROM Customers;

--what is avg list price  of all products in es prod category?
SELECT c.CategoryName, AVG(p.ListPrice) 'Average List Price'
  FROM Categories c JOIN Products p
    ON c.CategoryID = p.CategoryID
  GROUP BY c.CategoryName;

--Which orderitem record has smallest line total?
SELECT MIN((ItemPrice * Quantity) - DiscountAmount) as [Min invoice line total]
  FROM OrderItems;

  --how many orders does ea customer have?
SELECT c.CustomerID, c.LastName, c.FirstName, COUNT(o.OrderID) as [# of orders]
  FROM Customers c JOIN Orders o
    ON c.CustomerID = o.CustomerID
  GROUP BY c.CustomerID, c.LastName, c.FirstName
  ORDER BY [# of orders] DESC
	;

--just include cust greater than 1 order
SELECT c.CustomerID, c.LastName, c.FirstName, COUNT(o.OrderID) as [# of orders]
  FROM Customers c JOIN Orders o
    ON c.CustomerID = o.CustomerID
  GROUP BY c.CustomerID, c.LastName, c.FirstName
  HAVING COUNT(o.OrderDate) > 1
  ORDER BY [# of orders] DESC
	;


USE AP
SELECT VendorName, COUNT(*) as InvoiceQty,
AVG(InvoiceTotal) as InvoiceAvg
FROM Vendors JOIN Invoices
ON Vendors.VendorID = Invoices.VendorID
WHERE InvoiceTotal > 500
GROUP BY VendorName
ORDER BY InvoiceQty DESC;

USE MyGuitarShop
--	EXAMPLE 1 - Do we have any customers who have not placed orders?
SELECT c.customerID, c.FirstName, c.LastName
 FROM Customers c
 WHERE c.CustomerID NOT IN
	(SELECT DISTINCT CustomerID FROM Orders);

--	EXAMPLE 2 - Do we have any products that have not been purchased?

SELECT p.ProductID, p. Description, p.ProductCode
  FROM Products p
  WHERE p.ProductID NOT IN
	(SELECT DISTINCT ProductID FROM OrderItems);

--	EXAMPLE 3 - Which orders came from customers with a shipping address 
--				in Texas and when were they placed?

SELECT o.OrderID, o.OrderDate
  FROM Orders o
  WHERE o.CustomerID IN
	(SELECT c.CustomerID
	  FROM Customers c JOIN Addresses a
		ON c.CustomerID = a.CustomerID
	  WHERE c.ShippingAddressID = a.AddressID AND a.State = 'TX');

--	EXAMPLE 4 - Is the ShippingAddressId for each customer in the customer table the 
--				same ShipAddressId for each order placed by that customer?

		-- stage 1 - get a list of orders and shipping address ids
SELECT OrderID, OrderDate, CustomerID, ShipAddressID
FROM Orders;

		-- stage 2 - get a list of customers and shipping address ids
SELECT CustomerID, LastName, FirstName, ShippingAddressID
  FROM Customers;

		-- stage 3 - combine and restate as single query
SELECT o.OrderID, o.OrderDate, o.CustomerID, o.ShipAddressID
  FROM Orders o JOIN Customers c
    ON o.CustomerID = c.CustomerID AND o.ShipAddressID <> c.ShippingAddressID;

--	EXAMPLE 5 - List Customer name, email, orderID, order date, subtotal, ship amount, 
--				tax amount, order total (subTotal + ship + tax)

SELECT c.CustomerID, c.LastName, c.FirstName, c.EmailAddress, 
	   o.OrderID, o.OrderDate, oi.ItemTotal, o.ShipAmount, o.TaxAmount,
	   oi.ItemTotal + o.ShipAmount + o.TaxAmount AS orderTotal
  FROM Customers c JOIN Orders o 
	 ON c.CustomerID = o.CustomerID JOIN 
	 (SELECT li.OrderID, SUM((itemPrice * Quantity) - DiscountAmount) AS ItemTotal FROM OrderItems li GROUP BY li.OrderID) AS oi 
	  ON o.OrderID = oi.OrderID;