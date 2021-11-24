
--	EXAMPLE 1 - Create a copy of the Orders table to use for analysis purposes

SELECT *
INTO Analysis_Orders
FROM Orders;

--	Alternate Solution -- create a table structure and use INSERT
--	see p. 335, 340, 341 in the textbook for information about the CREATE statement

CREATE TABLE Analysis_Orders_2
(
  OrderID			INT			   NOT NULL,
  CustomerID        INT            NOT NULL,
  OrderDate         DATETIME       NOT NULL,
  ShipAmount        MONEY          NOT NULL,
  TaxAmount         MONEY          NOT NULL,
  ShipDate          DATETIME       NULL,
  ShipAddressID     INT            NOT NULL,
  CardType          VARCHAR(50)    NOT NULL,
  CardNumber        CHAR(16)       NOT NULL,
  CardExpires       CHAR(7)        NOT NULL,
  BillingAddressID  INT            NOT NULL
);

-- After table created, insert records from original table

INSERT INTO Analysis_Orders_2
SELECT OrderID, CustomerID, OrderDate, ShipAmount, TaxAmount, ShipDate, 
	   ShipAddressID, CardType, CardNumber, CardExpires, BillingAddressID
FROM Orders;

--	Alternate Solution 2 -- create a table using Designer and use INSERT
--	see p. 378-379 in the textbook for information using the designer 
--	to create a table

/*
--	Create a table named Analysis_Orders_3 using the Designer
--	Add the following columns to the new table

  OrderID			INT			   NOT NULL,
  CustomerID        INT            NOT NULL,
  OrderDate         DATETIME       NOT NULL,
  ShipAmount        MONEY          NOT NULL,
  TaxAmount         MONEY          NOT NULL,
  ShipDate          DATETIME       NULL,
  ShipAddressID     INT            NOT NULL,
  CardType          VARCHAR(50)    NOT NULL,
  CardNumber        CHAR(16)       NOT NULL,
  CardExpires       CHAR(7)        NOT NULL,
  BillingAddressID  INT            NOT NULL

*/

-- After table created, insert records from original table

/*

INSERT INTO Analysis_Orders_3
SELECT OrderID, CustomerID, OrderDate, ShipAmount, TaxAmount, ShipDate, 
	   ShipAddressID, CardType, CardNumber, CardExpires, BillingAddressID
FROM Orders;

*/

 --	EXAMPLE 2 - Create a copy of the customers table. Then, add yourself as a customer to the 
 --				analysis customer table. use addressID = 104 for your shippingAddressID and 
 --				your BillingAddressID

SELECT *
INTO Analysis_Customers
FROM Customers;

INSERT INTO Analysis_Customers -- no column list
VALUES
	('interestedstudent@tamu.edu', 'p@$$woRD', 'Interested', 'Student', 104, 104);

--	Alternate Solution -- create a table and use INSERT
--	see p. 335, 340, 341 in the textbook for information about the CREATE statement
 
CREATE TABLE Analysis_Customers_2
(
  CustomerID           INT            NOT NULL,
  EmailAddress         VARCHAR(255)   NOT NULL      UNIQUE,
  [Password]           VARCHAR(60)    NOT NULL,
  FirstName            VARCHAR(60)    NOT NULL,
  LastName             VARCHAR(60)    NOT NULL,
  ShippingAddressID    INT            NULL,
  BillingAddressID     INT            NULL
);


--	copy existing customers into new table

INSERT INTO Analysis_Customers_2
SELECT CustomerID, EmailAddress, [Password], FirstName, LastName, ShippingAddressID, BillingAddressID
FROM Customers;

--	add self as customer in new table

INSERT INTO Analysis_Customers_2 
	([Password], EmailAddress, LastName, ShippingAddressID, FirstName, BillingAddressID, CustomerID)
VALUES
	('p@$$woRD', 'interested_stu_dent@tamu.edu', 'Student', 104, 'Interested', 104, 
	(SELECT MAX(CustomerID) + 1 FROM Analysis_Customers_2)); 

--	EXAMPLE 3 - Add a customer to the Customer_Analysis table with new address. Create an 
--				analysis copy of the Adddresses table and use the new table to store the 
--				new adddress

INSERT INTO Analysis_Customers
	(FirstName, LastName, EmailAddress, [Password])
VALUES
	('Some', 'Student','somestudent@tamu.edu','pass1234');

SELECT * 
INTO Analysis_Addresses
FROM Addresses;

INSERT INTO Analysis_Addresses
VALUES
	(
	 (SELECT MAX(CustomerID) FROM Analysis_Customers),
	 '1234 Some Street',
	 NULL,
	 'College Station',
	 'TX',
	 '77845',
	 '979-123-4567',
	  0
	 );

UPDATE Analysis_Customers
SET ShippingAddressID = (SELECT MAX(AddressID) FROM Analysis_Addresses)
WHERE CustomerID = (SELECT MAX(CustomerID) FROM Analysis_Customers);

UPDATE Analysis_Customers
SET BillingAddressID = (SELECT MAX(AddressID) FROM Analysis_Addresses)
WHERE CustomerID = (SELECT MAX(CustomerID) FROM Analysis_Customers);

--	EXAMPLE 4 - Delete the customer and address data you added

DELETE FROM Analysis_Customers
WHERE FirstName = 'Interested' AND LastName = 'Student';

SELECT *
FROM Analysis_Customers
--DELETE FROM Analysis_Customers
WHERE ShippingAddressID = (SELECT MAX(AddressID) FROM Analysis_Addresses);

DELETE FROM Analysis_Addresses
WHERE AddressID = 513 AND CustomerID = 490;

--	EXAMPLE 5 - Delete the "Analysis" tables from the database

/*

DROP TABLE Analysis_Orders;
DROP TABLE Analysis_Orders_2;
DROP TABLE Analysis_Orders_3;
DROP TABLE Analysis_Customers;
DROP TABLE Analysis_Customers_2;
DROP TABLE Analysis_Addresses;

*/

/*	Alternative Solution -- you could also do one of the following to remove the "Analysis" tables

		Option 1 - In the Object Explorer, right-click on the table name and choose "Delete" from
		the menu. Then click OK in the confirmation dialog box. 

		Option 2 - In the Object Explorer, left-click on the table name and press the "Delete" 
		key on the keyboard. Then click OK in the confirmation dialog box.

*/