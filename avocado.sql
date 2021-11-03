--	Learning Module 10 IN-CLASS QUESTIONS ABOUT THE AVOCADO DATA

--	List the average price, sale date, and total volume for all records

SELECT AveragePrice, SalesDate, Total_Volume
  FROM AvocadoSales;

--	List the unique regions in the Avocado data set

SELECT DISTINCT SalesRegion
  FROM AvocadoSales;

--	List the unique sales types in the data set sort the results 
--	alphabetically

SELECT DISTINCT SalesType
  FROM AvocadoSales
  ORDER BY SalesType;

--	List the average price, total bags, type, sales year for all sales 
--	in the Denver region with no extra large bag sales 
--	(e.g., Xlarge_bags = '0' (zero)) 
--	NOTE: use Xlarge_bags = '0' because data type is string instead of
--	numeric. We will learn about changing data types later. 

SELECT AveragePrice, Total_Bags, SalesType, SalesYear
  FROM AvocadoSales
  WHERE SalesRegion = 'Denver' AND XLarge_Bags = '0.0';

--	List the region, sales year, and average price for the 15 lowest 
--	average price records

SELECT TOP 15 SalesRegion, SalesYear, AveragePrice
  FROM AvocadoSales
  ORDER BY AveragePrice DESC;

--	List all data for records with average price between $1.00 and 
--	$1.50 sort by average price

--	OPTION 1
SELECT *
  FROM AvocadoSales
  WHERE AveragePrice >= 1.00 AND AveragePrice <= 1.50
  ORDER BY AveragePrice;

--	OPTION 2
SELECT *
  FROM AvocadoSales
  WHERE AveragePrice BETWEEN 1.00 AND 1.50
  ORDER BY AveragePrice;

--	What are the five lowest average prices?

SELECT TOP 5 SalesRegion, SalesYear, AveragePrice
  FROM AvocadoSales
  ORDER BY 3;

--	What market region has the highest average price for avocados? Your 
--	response should only list one record and should include sale date, 
--	average price, total volume, sales type, and region. 
--	HINT: Do not use summary queries! We will learn summary queries later.

SELECT TOP 1 SalesDate, AveragePrice, Total_Volume, SalesType, SalesRegion
  FROM AvocadoSales
  ORDER BY AveragePrice DESC;


-- List the average price (remember column name = AveragePrice), sale date, and total volume for all records
SELECT 
  AveragePrice,
  SalesDate,
  Total_Volume
  FROM Avocado;

-- List the unique sales regions in the Avocado data set
SELECT DISTINCT SalesRegion
FROM avocado;
-- List the unique sales types in the data set sort the results alphabetically

-- List the average price, total bags, type, sales year for all sales in the Denver region with no extra-large bag sales (e.g., Xlarge_Bags = ‘0’ (zero)) 

-- List the region, sales year, and average price for the 15 lowest average price records

-- List all data for records with average price greater than or equal to 3.00

-- What are the five lowest average prices?

-- What market region has the highest average price for avocados? Your response should only list one record and should include sale date, average price, total volume, sales type, and region. (HINT: Do not use summary queries!)
