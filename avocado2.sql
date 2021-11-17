--What is the average price, average volume, and average total bags for avocado sales?
SELECT AVG(AveragePrice) AvgPrice, AVG(Total_Volume) AvgVol, AVG(Total_Bags) AvgBags
  FROM avocado;

--By year?
SELECT EXTRACT(YEAR FROM SalesDate)
  FROM avocado;
SELECT YEAR(SalesDate)
  FROM avocado;
SELECT AVG(AveragePrice) AvgPrice, AVG(Total_Volume) AvgVol, AVG(Total_Bags) AvgBags
  FROM avocado
  GROUP BY YEAR(SalesDate);
--By region, by year?
SELECT AVG(AveragePrice) AvgPrice, AVG(Total_Volume) AvgVol, AVG(Total_Bags) AvgBags
  FROM avocado
  GROUP BY YEAR(SalesDate), SalesRegion;

SELECT AVG(AveragePrice) AvgPrice, AVG(Total_Volume) AvgVol, AVG(Total_Bags) AvgBags, SalesRegion
  FROM avocado
  GROUP BY SalesRegion, YEAR(SalesDate);

--By sales type, by region?
SELECT AVG(AveragePrice) AvgPrice, AVG(Total_Volume) AvgVol, AVG(Total_Bags) AvgBags
  FROM avocado
  GROUP BY SalesType, SalesRegion;

--By sales type, by region, by year?
SELECT AVG(AveragePrice) AvgPrice, AVG(Total_Volume) AvgVol, AVG(Total_Bags) AvgBags
  FROM avocado
  GROUP BY YEAR(SalesDate), SalesType, SalesRegion;

--How many regions are in the data set?
SELECT COUNT(DISTINCT SalesRegion)
  FROM avocado;

--How many years are in the data set?
SELECT COUNT(DISTINCT YEAR(SalesDate))
  FROM avocado;

--What is the range of years in the data set?
SELECT DISTINCT YEAR (SalesDate) yr
  FROM avocado
  ORDER BY yr;

--Which regions had average prices for the year during 2015 that exceeded the overall average price for the year (i.e., what are the regions that have higher average prices)?

SELECT SalesRegion, AVG(AveragePrice) yravgp
  FROM avocado
  WHERE SalesYear = 2015
  GROUP BY SalesRegion
  HAVING AVG(AveragePrice) > 
    (SELECT AVG(AveragePrice)
	  FROM avocado
	    WHERE SalesYear = 2015);

SELECT AVG(AveragePrice)
FROM [dbo].[avocado]
WHERE SalesYear = 2015;
-- avg price 2015 (per region)
SELECT SalesRegion, AVG(AveragePrice) [2015 Average Price]
FROM [dbo].[avocado]
WHERE SalesYear = 2015
GROUP BY SalesRegion
ORDER BY [2015 Average Price] DESC;
-- and put together


SELECT SalesRegion, AVG(AveragePrice) [2015 Average Price]
FROM avocado
WHERE SalesYear = 2015
GROUP BY SalesRegion
HAVING AVG(AveragePrice) > (SELECT AVG(AveragePrice)
FROM avocado
WHERE SalesYear = 2015
)
ORDER BY [2015 Average Price] DESC;