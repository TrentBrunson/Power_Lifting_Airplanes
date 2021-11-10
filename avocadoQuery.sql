select * from avocado;

-- select unique regions from avaocado dataset
SELECT SalesRegion
 FROM Avocado;

 SELECT DISTINCT SalesRegion
 FROM Avocado;

 SELECT AveragePrice, SalesDate, Total_Volume
  FROM avocado

--	List the unique sales types in the data set sort the results 
--	alphabetically

SELECT DISTINCT SalesType
FROM Avocado
ORDER BY SalesType;

--	List the average price, total bags, type, sales year for all sales 
--	in the Denver region with no extra large bag sales 
--	(e.g., Xlarge_bags = '0' (zero)) 
--	NOTE: use Xlarge_bags = '0' because data type is string instead of
--	numeric. We will learn about changing data types later. 

SELECT AveragePrice, Total_Bags, SalesType, SalesYear
FROM Avocado
WHERE SalesRegion = 'Denver' AND XLarge_Bags = '0.0';

--	List the region, sales year, and average price for the 15 lowest 
--	average price records

SELECT TOP 15 SalesRegion, SalesYear, AveragePrice
  FROM Avocado
  ORDER BY AveragePrice DESC;

--	List all data for records with average price between $1.00 and 
--	$1.50 sort by average price

--	OPTION 1
SELECT *
  FROM Avocado
  WHERE AveragePrice >= 1.00 AND AveragePrice <= 1.50
  ORDER BY AveragePrice;

--	OPTION 2
SELECT *
  FROM Avocado
  WHERE AveragePrice BETWEEN 1.00 AND 1.50
  ORDER BY AveragePrice;

--	What are the five lowest average prices?

SELECT TOP 5 SalesRegion, SalesYear, AveragePrice
  FROM Avocado
  ORDER BY 3;

--	What market region has the highest average price for avocados? Your 
--	response should only list one record and should include sale date, 
--	average price, total volume, sales type, and region. 
--	HINT: Do not use summary queries! We will learn summary queries later.

SELECT TOP 1 SalesDate, AveragePrice, Total_Volume, SalesType, SalesRegion
  FROM Avocado
  ORDER BY AveragePrice DESC;

-- When and where were the most small bags sold?
select top 1 SalesRegion, SalesDate, Small_Bags
from avocado 
where SalesRegion <> 'TotalUS'
order by Small_Bags desc;

-- How many total avocados were sold in Houston?
select SalesRegion, sum(Total_Volume) as Total
from avocado
where SalesRegion = 'Houston'
group by SalesRegion;

--How many bags total of each type(conventional & organic) were sold?
select SalesType, sum(Total_Bags) as Total
from avocado
group by SalesType;
