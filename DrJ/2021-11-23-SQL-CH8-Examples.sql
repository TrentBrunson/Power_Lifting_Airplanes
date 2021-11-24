
--	View the first 1000 rows of data in the newly imported table

SELECT TOP 1000 *
FROM Career_Stats_Receiving;

--	Are there any players in receiving data that are not in basic stats data

SELECT DISTINCT [Player Id]
FROM Career_Stats_Receiving
WHERE [Player Id] NOT IN 
	(SELECT DISTINCT [Player Id] FROM Basic_Stats);

--	It appears that all players in the Career_Stats_Receiving are in the Basic_Stats table

--	Let's create a copy of career_stats_receiving to use for analysis

SELECT * 
INTO Career_Stats_Receiving_Analysis
FROM Career_Stats_Receiving

-- Look at the receiving data in the analysis table

SELECT TOP 1000 *
FROM Career_Stats_Receiving_Analysis;

-- Any empty values in player id or name

SELECT *
FROM Career_Stats_Receiving_Analysis
WHERE [Player Id] = '';

--	It appears that all career_stats_receiving records have a player id

SELECT * 
FROM Career_Stats_Receiving_Analysis
WHERE PlayerName = '';

--	It appears that all career_stats_receiving records have a player name

-- Explore Games Played column

SELECT [Games Played], COUNT(*)
FROM Career_Stats_Receiving_Analysis
GROUP BY [Games Played]
ORDER BY [Games Played];

--	a number of records have zero games played
--	the range of games played is 0 to 17
--	are the 0 games played and 17 games played values reasonable?

--	explore zero games played

SELECT *
FROM Career_Stats_Receiving_Analysis
WHERE [Games Played] = '0';

SELECT *
FROM Career_Stats_Receiving_Analysis
WHERE PlayerName LIKE 'Basnight, M%' OR PlayerName LIKE 'Taylor, Tr%';

--	zero games played seems reasonable
--	however, all other columns in seasons with 0 games played are 0 or --

-- explore 17 games played

SELECT *
FROM Career_Stats_Receiving_Analysis
WHERE [Games Played] = '17';

-- interesting that each player has at least one Receiving TD but not receptions or receiving yards

SELECT *
FROM Career_Stats_Receiving_Analysis
WHERE Season = '1930'
ORDER BY Team;

--	wide variation in number of games played in 1930 season
--	explore using Google 
--	found Wikipedia page for 1930 season
--	https://en.wikipedia.org/wiki/1930_NFL_season
--	conclusion 17 games played seems reasonable

--	interesting observations...
--	the 1930 season had 11 teams (see Wikipedia page)
--	there were only 21 receivers across those 11 teams
--	only 10 teams had receivers in the 1930 season

SELECT DISTINCT Team 
FROM Career_Stats_Receiving_Analysis 
WHERE season = '1930';

-- EXPLORE RECEPTIONS COLUMN

SELECT Receptions, COUNT(*) '# of records'
FROM Career_Stats_Receiving_Analysis
GROUP BY Receptions
ORDER BY '# of records' DESC;

SELECT Receptions, COUNT(*) '# of records'
FROM Career_Stats_Receiving_Analysis
GROUP BY Receptions
ORDER BY Receptions;

-- a number of records (4404) have '--' as values. this data value comes from the original data set
-- It appears these values are not known, thus, I would like to change these values to NULL
-- other numbers apppear reasonable. I will change the data to numeric data type. Because receptions
-- will always be whole number, I will use integer data type

--	In addition, a number of records (245) have '0' receptions

--	add column for storing clean data values
--	see p. 335, 354-355 in textbook for additional details about ALTER syntax

ALTER TABLE Career_Stats_Receiving_Analysis
ADD [Clean Receptions] int NULL;

-- the NULL keyword in previous query does two things 1) it defines the new column as
-- nullable (i.e., will accept null values) and 2) sets the value in each new row as null

SELECT *
FROM Career_Stats_Receiving_Analysis;

--	could also add column using Table Designer
--	right-click on table name in Object Explorer and choose Design from the menu
--	add column in the Designer window

/*

	If IntelliSense shows a red squiggly line under [Clean Receptions] after adding
	the column, you need to refresh the screen cache memory by doing one of the following:
	-- press CTRL+SHIFT+R on the keyboard
	-- select Edit -> IntelliSense -> Refresh Local Cache from the menu
	(sometimes you might also need to refresh the Object Explorer and then do the above)

*/

-- Update table to clean reception data and place in new column
-- first query is for existing numeric values

UPDATE Career_Stats_Receiving_Analysis
SET [Clean Receptions] = CAST(Receptions as int)
WHERE Receptions <> '--';

-- validate numeric sort
SELECT Receptions, COUNT(*) '# of records'
FROM Career_Stats_Receiving_Analysis
GROUP BY Receptions
ORDER BY Receptions DESC;

SELECT [Clean Receptions], COUNT(*) '# of records'
FROM Career_Stats_Receiving_Analysis
GROUP BY [Clean Receptions]
ORDER BY [Clean Receptions] DESC;

/*

	See https://www.cbssports.com/nfl/news/michael-thomas-passes-marvin-harrison-for-most-single-season-receptions-in-nfl-history/

*/

UPDATE Career_Stats_Receiving_Analysis
SET [Clean Receptions] = NULL
WHERE Receptions = '--';

-- explore Longest Reception column

SELECT [Longest Reception], COUNT(*) '# of records'
FROM Career_Stats_Receiving_Analysis
GROUP BY [Longest Reception]
ORDER BY [Longest Reception] DESC;

--	A number of records have 'T' after the number in the longest reception column

SELECT [Longest Reception], COUNT(*) '# of records'
FROM Career_Stats_Receiving_Analysis
GROUP BY [Longest Reception]
ORDER BY '# of records' DESC;

--	A number of records (8627) have '--' as longest reception. I will explore that more.

SELECT *
FROM Career_Stats_Receiving_Analysis
WHERE [Longest Reception] = '--';

--	I observe a problem in the data. While many records with '--' in the longest reception
--	column also have '--' in the other columns (e.g., receptions, receiving yards, etc.), some
--	columns have values in these other columns. For example, Stu Voight played 14 games in 1974
--	with 32 receptions and 268 receiving yards; however, the longest reception column has '--'
--	I could not find a means of deriving longest reception from the other columns. For now,
--	I am ignoring this anonomly. 

--	Because 8627 represents about 48% of the data, I may not be
--	able to use the 'longest reception' column in statistical analysis. 

--	I decided to replace all '--' values with NULL


--	Several values have the letter 'T' at the end of the character string. I could not find any
--	information on the NFL website about the 'T'. I am guessing the 'T' indicates a touchdown.
--	I will handle this in the clean data set by adding two columns. One column to hold the 
--	numeric values for the longest reception and one to hold a "flag" for whether the
--	player scored a touchdown with their longest reception

ALTER TABLE Career_Stats_Receiving_Analysis
ADD [Clean Longest Reception] int NULL;

ALTER TABLE Career_Stats_Receiving_Analysis
ADD [Clean Longest Reception was TD] bit NULL;

UPDATE Career_Stats_Receiving_Analysis
SET [Clean Longest Reception] = CAST([Longest Reception] AS int)
WHERE [Longest Reception] <> '--' AND [Longest Reception] NOT LIKE '%T';

--	we can parse the 'T' from the string using LEN and LEFT string manipulation
--	see p. 262-267 in the textbook for information about the LEN and LEFT functions

SELECT	[Longest Reception], LEN([Longest Reception]) AS 'String Length', 
		LEFT([Longest Reception], (LEN([Longest Reception])-1)) AS 'Clean Longest Reception'
FROM Career_Stats_Receiving_Analysis
WHERE [Longest Reception] LIKE '%T'
ORDER BY 'String Length' DESC;

--	Parse the longest reception yards and store in clean longest reception

UPDATE Career_Stats_Receiving_Analysis
SET [Clean Longest Reception] = 
		CAST(LEFT([Longest Reception], (LEN([Longest Reception])-1)) AS int)
WHERE [Longest Reception] LIKE '%T';

--	Set [Clean Longest Reception as TD] = 1 when longest reception is a TD
UPDATE Career_Stats_Receiving_Analysis
SET [Clean Longest Reception was TD] = 1
WHERE [Longest Reception] LIKE '%T';

--	Set [Clean Longest Reception as TD] = 0 when longest reception is NOT a TD
UPDATE Career_Stats_Receiving_Analysis
SET [Clean Longest Reception was TD] = 0
WHERE [Longest Reception] <> '--' AND [Longest Reception] NOT LIKE '%T';

SELECT [Longest Reception], [Clean Longest Reception], [Clean Longest Reception was TD]
FROM Career_Stats_Receiving_Analysis
WHERE [Longest Reception] LIKE '%T';

--DROP TABLE Career_Stats_Receiving_Analysis;
