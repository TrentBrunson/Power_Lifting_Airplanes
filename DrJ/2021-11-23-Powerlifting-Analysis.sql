--	CONSIDER THE LIFTER DATA

SELECT COUNT(*)
FROM lifters;

--	386,614 records

--	CREATE ANALYSIS COPY OF DATA
SELECT *
INTO lifters_analysis
FROM lifters1; -- correcting for my previous corrections; using the bad data types from ex

SELECT COUNT(*)
FROM lifters_analysis;

--	386,614 records

--	NAME COLUMN

--	any blank names
SELECT *
FROM lifters_analysis
where LifterName = '' OR LifterName IS NULL;

--	no blank names

SELECT LifterName, COUNT(*)
FROM lifters_analysis
GROUP BY LifterName;

--	 no unexpected values

SELECT *
FROM lifters_analysis
WHERE LifterName = 'Christian Garcia';

--	 SEX COLUMN

SELECT Sex, COUNT(*)
FROM lifters_analysis
GROUP BY Sex;

--	 No unexpected values

--	EQUIPMENT COLUMN

SELECT Equipment, COUNT(*)
FROM lifters_analysis
GROUP BY Equipment;

--	no unexpected values. only seven records have "straps" as equipment. 
--	small number of "straps" records will limit conclusions on that
--	equipment type

--	AGE COLUMN	

SELECT Age, COUNT(*)
FROM lifters_analysis
GROUP BY Age
ORDER BY Age;

--	239,267 records (62% of data) with no age 
--	no birthdate stored; therefore cannot generate unless seek out additional data
--	age appears to be stored in half year increments
--	multiple records with age < 15
--	multipe records with age > 70
--	looks like age could be converted to decimal data type
--	I will convert empty age fields to NULL

--	add column to store clean age data and then cast the age string as int

ALTER TABLE lifters_analysis
ADD Clean_Age decimal(6,1) NULL;

select * from lifters_analysis

UPDATE lifters_analysis
SET Clean_Age = CAST(Age as decimal(6,1))
WHERE Age <> '';

SELECT Age, Clean_Age, COUNT(*)
FROM lifters_analysis
GROUP BY age, Clean_Age
ORDER BY Clean_Age;

--	I will explore the age < 15 column 

SELECT *
FROM lifters_analysis
WHERE Clean_Age < 15
ORDER BY Clean_Age;

--	2,131 lifters under age 15 in the dataset
--	I will explore this more after cleaning body weight column

--	DIVISION COLUMN

SELECT Division, COUNT(*)
FROM lifters_analysis
GROUP BY Division
ORDER BY Division;

--	15,843 records with no value
--	4,081 different divisions
--	appears to have some duplication in divisions (e.g., '13-15 Junior' and '13-15 Junior Men' and 'AD Junior')
--	need some additional cleaning in division data. some additional research might reveal some consistent
--	divisions or a cross listing table to determine if divisions are related (see example above)
--	will exclude division from final data set for now due to time constraints (i.e., not enough time
--	to research division and clean the column)

--	BODYWEIGHTKG COLUMN

SELECT BodyweightKg, COUNT(*)
FROM lifters_analysis
GROUP BY BodyweightKg
ORDER BY BodyweightKg;

--	2,402 records with no value
--	10,513 differnt body weights
--	appears that body weight has no unexpected values and the data could be converted to decimal data type
--	I will use decimal(10,2) to retain two places to the right of the decimal
--	I will convert empty records to NULL values

ALTER TABLE lifters_analysis
ADD Clean_BodyWeight decimal(10,2) NULL;

UPDATE lifters_analysis
SET Clean_BodyWeight = CAST(BodyweightKg as decimal(10,2))
WHERE BodyweightKg <> '';

SELECT Clean_BodyWeight, COUNT(*)
FROM lifters_analysis
GROUP BY Clean_BodyWeight
ORDER BY Clean_BodyWeight;

--	I will explore the age < 15 a bit further
SELECT LifterName, Sex, Clean_Age, 
		Clean_BodyWeight AS [Body Weight in KG], 
		Clean_BodyWeight * 2.20462 AS [Body Weight in lbs]
FROM lifters_analysis
WHERE Clean_Age < 15
ORDER BY Sex, Clean_Age, [Body Weight in lbs];

--	The ages and weights seem reasonable. 
--	see Berlynn Shamblin (https://www.openpowerlifting.org/u/berlynnshamblin)
--	see Matthew Martinez (https://www.openpowerlifting.org/u/matthewmartinez)

--	On the Matthew Martinez open powerlifting page, I saw that Matt is from Texas
--	and lifted at an A&M Consolidated High School meet. This led me to wonder about my
--	son Jason who lifted in high school. The next set of queries explores the information
--	about my son. 

SELECT *
FROM lifters_analysis
WHERE LifterName like '%Jasperson%'
ORDER BY LifterName, MeetID;

SELECT	M.MeetID,
		M.MeetDate,
		M.MeetTown,
		M.MeetTown,
		L.LifterName,
		l.Clean_BodyWeight,
		--L.Clean_WeightClass,
		L.BestSquatKg,
		L.BestBenchKg,
		L.BestDeadliftKg,
		L.TotalKg
FROM	lifters_analysis L JOIN Meets M
		ON L.MeetID = M.MeetID
WHERE	L.LifterName = 'Jason Jasperson';

--	I have used this dataset since Fall 2018 and just discovered today (Nov 23, 2021) that the data includes 
--	my son's lifting data from high school. (https://www.openpowerlifting.org/u/jasonjasperson)

--	WEIGHTCLASSKG COLUMN

SELECT WeightClassKg, COUNT(*)
FROM lifters_analysis
GROUP BY WeightClassKg
ORDER BY WeightClassKg;

--	3,812 records with no value
--	52 differnt body weights
--	several weight class values include a +
--	need more research to determine the meaning behind the +
--	appears that weight class has no unexpected values and the data could be converted to decimal data type
--	I will use decimal(6,1) to retain one place to the right of the decimal
--	I will convert empty records to NULL values
--	for values that include +, I will drop the + and convert the number to decimal value 
--	I will also add a column to capture the plus concept

--	column for clean weight class
ALTER TABLE lifters_analysis
ADD Clean_WeightClass decimal(6,1) NULL;

--	column to capture plus
ALTER TABLE lifters_analysis
ADD Clean_WeightClass_Plus int NULL;

select * from lifters_analysis

--	I used the following query to make sure my case statemnt worked correctly to parse out the + values

SELECT WeightClassKg, 
		CASE 
			--WHEN WeightClassKg <> '' THEN 'NOT BLANK'
			--WHEN RIGHT(WeightClassKg, 1) = '+' THEN LEFT(WEIGHTCLASSKG, LEN(WEIGHTCLASSKG)-1)
			--      RIGHT(84+, 1)
			WHEN WeightClassKg LIKE '%+' THEN LEFT(WeightClassKg, LEN(WeightClassKg)-1)
			--                                LEFT(84+, 3-1) 
			WHEN WeightClassKg <> '' THEN 'NOT BLANK'
		END
FROM lifters_analysis;

--	change the weight class data to decimal data type for clean weight class column
UPDATE lifters_analysis
SET Clean_WeightClass = 
		CASE
			WHEN WeightClassKg LIKE '%+' THEN CAST(LEFT(WeightClassKg, LEN(WeightClassKg)-1) AS decimal(6,1))
			WHEN WeightClassKg <> '' THEN CAST(WeightClassKg as decimal(6,1))
		END;

SELECT WeightClassKg, Clean_WeightClass FROM lifters_analysis 

--	enter 1 for weight class plus column when original weight class has a +
--	enter 0 for weight class plus column when original weight class did not have +
UPDATE lifters_analysis
SET Clean_WeightClass_Plus = 
		CASE
			WHEN WeightClassKg LIKE '%+' THEN 1		--	1 means record had a + weight class
			WHEN WeightClassKg <> '' THEN 0			--	0 means record did not have a + weight class
		END;

SELECT Clean_WeightClass_Plus, COUNT(*)
FROM lifters_analysis
GROUP BY Clean_WeightClass_Plus
ORDER BY Clean_WeightClass_Plus;

--	25,813 records have a+ weight class 

-- Squat4Kg Column

SELECT Squat4Kg, COUNT(*)
FROM lifters_analysis
GROUP BY Squat4Kg
ORDER BY Squat4Kg;

--	385,171 records have no value ... this represents 99.68% of the data
--	I will not be able to use the Squat4Kg column in further analysis

--	BESTSQUATKG COLUMN

SELECT BestSquatKg, COUNT(*)
FROM lifters_analysis
GROUP BY BestSquatKg
ORDER BY BestSquatKg;

--	88,343 records have no value for best squat ... I will convert to NULL
--	The numbers have two significant digits to the right of the decimal
--	a number of records have negative numbers for best squat ... I will explore this

SELECT *
FROM lifters_analysis
WHERE BestSquatKg LIKE '-%';

--	many records with negative best squat have DQ (disqualified) in the Place column 

SELECT [Place], COUNT(*)
FROM lifters
WHERE BestSquatKg NOT LIKE '-%'
GROUP BY [Place]
ORDER BY [Place];

--	all records except 2 have DQ ... The negative numbers appear valid based on the DQ status
--	I will retain the negative numbers
--	I will convert the data to decimal(8,2)

ALTER TABLE lifters_analysis
ADD Clean_BestSquatKG decimal(8,2) NULL;

UPDATE lifters_analysis
SET Clean_BestSquatKG = CAST(BestSquatKg as decimal(8,2))
WHERE BestSquatKg <> '';

SELECT Clean_BestSquatKG, COUNT(*)
FROM lifters_analysis
GROUP BY Clean_BestSquatKG
ORDER BY Clean_BestSquatKG;

--	the max squat = 573.79 KG (or 1,265 lbs)




--	Finish the data cleaning exercise for the remainign columns in the table