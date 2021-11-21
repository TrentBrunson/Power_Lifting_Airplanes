-- After reviewing the data contained in the "Basic_Stats" and "Career_Stats_Defensive" tables, 
-- post a question to the discussion board that can be answered with a single table or joined table query. 

SELECT * FROM Basic_Stats
WHERE College = 'No College';

SELECT COUNT(College)
  FROM Basic_Stats
  WHERE College = 'No College';

SELECT DISTINCT bs.[Player Name], bs.[Weight in lbs]
  FROM Basic_Stats bs JOIN Career_Stats_Defensive CS
  ON bs.[Player Id] = cs.[Player Id]
  WHERE bs.[Weight in lbs] >= 250 AND cs.[Ints for TDs] >= '1';

  -- ****************************
SELECT DISTINCT bs.[Player Name], bs.[Weight in lbs] 
FROM [Basic_Stats] bs, [Career_Stats_Defensive] cs
WHERE  bs.[Player Id] = cs.[Player Id] and bs.[Weight in lbs] > 250 and cs.[Ints for TDs] > '1';

-- good one:
SELECT COUNT(DISTINCT cs.[Player Name])
  FROM Basic_Stats bs JOIN Career_Stats_Defensive CS
  ON bs.[Player Id] = cs.[Player Id]
  WHERE bs.[Weight in lbs] >= 250 AND cs.[Ints for TDs] >= '1';

SELECT * FROM Career_Stats_Defensive;

SELECT * FROM Basic_Stats;

-- List the year and number of games played by Taylor, Lawrence.

-- check spelling for lawrence
SELECT DISTINCT [Player Name] FROM Career_Stats_Defensive;

SELECT Season, [Games Played]
  FROM Career_Stats_Defensive 
  WHERE [Player Name] LIKE 'Taylor, L%';

-- use wild card

SELECT Season, [Games Played]
  FROM Career_Stats_Defensive
  WHERE [Player Name] = "Taylor, L%"

-- List the player ID, player name, and number for all players with a current status of Retired also have over 80 Solo Tackles
SELECT bs.[Player Id], bs.[Player Name], bs.Number, cs.[Solo Tackles]
  FROM Basic_Stats bs JOIN Career_Stats_Defensive cs
    ON bs.[Player Id] = cs.[Player Id]
  WHERE bs.[Current Status] = 'Retired' AND Try_Cast(cs."Solo Tackles" as int) > 80;

-- List player name, college, years played, and have experience of more than 3 season. 
SELECT [Player Name], College, [Years Played]
  FROM Basic_Stats
  WHERE Experience > 3;

  SELECT [Player Name], College, [Years Played]
  FROM Basic_Stats
  WHERE Experience > 3;

SELECT 
  Experience as e, 
  SUBSTRING(Experience, PATINDEX('%[0-9]%', Experience), LEN(Experience)) 
    FROM Basic_Stats;

select substring(Experience, PatIndex('%[0-9]', Experience), len(Experience)) as number from Basic_Stats

SELECT LEFT(Experience,CHARINDEX(' ', Experience)),
    LEFT(Experience,PATINDEX('%[^0-9]%',Experience))
	FROM Basic_Stats


DECLARE @string varchar(100)

SET @string = '12345 Test Address Dr.'

SELECT LEFT(Experience,CHARINDEX(' ', Experience)) FROM Basic_Stats

SELECT Experience
  FROM Basic_Stats
  WHILE PATINDEX('%[^0-9]%',Experience) <> 0
    SET new = STUFF(Experience,PATINDEX('%[^0-9]%',@string),1,'')

DECLARE @string varchar(100)

SET @string = 'sk123;fja4567afj;as890'

WHILE PATINDEX('%[^0-9]%',@string) <> 0

    SET @string = STUFF(@string,PATINDEX('%[^0-9]%',@string),1,'')

SELECT @string

SELECT Experience
  FROM Basic_Stats
  WHILE PATINDEX('%[^0-9]%',Experience) <> 0
    SET @string = STUFF(@string,PATINDEX('%[^0-9]%',@string),1,'')

Select PatIndex('%[0-9.-]%', Experience) as num FROM Basic_Stats;

-- List player ID, player name, height, birth place, team, and count passes defended for each player.
SELECT DISTINCT cs.[Player Id], bs.[Player Name], [Height in inches], [Birth Place], [Current Team], [Passes Defended]
--, COUNT()
  FROM Basic_Stats bs JOIN Career_Stats_Defensive cs
  ON bs.[Player Id] = cs.[Player Id]
  --GROUP BY cs.[Player Id]
  ORDER BY cs.[Player Id] DESC
  --ORDER BY cs.[Passes Defended] DESC;;

-- Working
SELECT DISTINCT cs.[Player Id], bs.[Player Name], [Height in inches], [Birth Place], [Current Team], Try_Cast([Passes Defended] as int) as [Passes Defended]
  FROM Basic_Stats bs JOIN Career_Stats_Defensive cs
  ON bs.[Player Id] = cs.[Player Id]
  ORDER BY [Passes Defended] DESC;

  -- order by name
SELECT DISTINCT cs.[Player Id], bs.[Player Name], [Height in inches], [Birth Place], [Current Team], Try_Cast([Passes Defended] as int) as [Passes Defended]
  FROM Basic_Stats bs JOIN Career_Stats_Defensive cs
  ON bs.[Player Id] = cs.[Player Id]
  ORDER BY bs.[Player Name] DESC;

-- redo this by group by name without passes defended
SELECT DISTINCT cs.[Player Id], bs.[Player Name], [Height in inches], [Birth Place], [Current Team]
  FROM Basic_Stats bs JOIN Career_Stats_Defensive cs
  ON bs.[Player Id] = cs.[Player Id]
  ORDER BY bs.[Player Name] DESC;
  
  -- now sum the passes defended
  SELECT 
    cs.[Player Id],
	cs.[Player Name],
	[Height in inches],
	[Birth Place],
	[Current Team],
	SUM(Try_Cast([Passes Defended] as int)) Passes_Defended
  FROM 
    Career_Stats_Defensive cs JOIN Basic_Stats bs
	  ON cs.[Player Id] = bs.[Player Id]
  GROUP BY
	cs.[Player Id], cs.[Player Name], [Height in inches], [Birth Place], [Current Team]
  ORDER BY
    Passes_Defended DESC;


SELECT DISTINCT B.[Player Name], B.[Weight in lbs], [Ints for TDs]
FROM Basic_Stats B, Career_Stats_Defensive C
WHERE  B.[Player Id] = C.[Player Id] and B.[Weight in lbs] > 280 and C.[Ints for TDs] >= '1';

SELECT [Player Name],College,[Years Played],Experience
FROM Basic_Stats
WHERE Experience > '3';

SELECT temp.[Player Name], College, temp.[Years Played] FROM
(SELECT cs.[Player Name], bs.College, bs.[Years Played], COUNT(cs.Season) as SeasonCount
FROM Career_Stats_Defensive AS cs INNER JOIN Basic_Stats as bs
ON cs.[Player Id] = bs.[Player Id]
GROUP BY cs.[Player Name], bs.College, bs.[Years Played]
HAVING COUNT(cs.Season) >= 3) as temp

 SELECT C.[Player Id],C.[Player Name],B.Number 
  FROM Basic_Stats B JOIN Career_Stats_Defensive C
  ON B.[Player Id] = C.[Player Id] 
  WHERE B.[Current Status] = 'Retired' and C.[Solo Tackles] > '80';

  SELECT C.[Player Id],C.[Player Name],B.Number 
  FROM Basic_Stats B JOIN Career_Stats_Defensive C
  ON B.[Player Id] = C.[Player Id] 
  WHERE B.[Current Status] = 'Retired' and C.[Solo Tackles] > '80';

SELECT DISTINCT(c.[Player Name]), b.Birthday, c.[Ints for TDs]
  FROM Basic_Stats b JOIN Career_Stats_Defensive c
	ON b.[Player Id] = c.[Player Id]
  WHERE MONTH(b.Birthday) = 02
  GROUP BY b.Birthday, c.[Player Name], c.[Ints for TDs]
  HAVING TRY_CAST(c.[Ints for TDs] as INT) >= 2;

SELECT MAX(t.c) [# players]
  FROM 
	(SELECT DISTINCT ([Current Team]), COUNT([Player Name]) c
	  FROM Basic_Stats
	  WHERE [Current Team] <> ''
	  GROUP BY [Current Team] --ORDER BY c DESC
	  ) t;

SELECT [Current Team], COUNT([Current Team]) [# of players]
  FROM Basic_Stats
  GROUP BY [Current Team]
  HAVING COUNT([Current Team]) = ( 
		-- set condition to only return the max value from the sub-query
		-- this limits the select values for current team to be the one with the most
	SELECT MAX(total)  -- get the maximum value from the inner query
	  FROM 
	    ( -- get number of players on teams
		SELECT [Current Team], COUNT([Player Id]) total
		  FROM Basic_Stats
		  WHERE [Current Team] <> ''
		  GROUP BY [Current Team]) t);


-- how to add team name to this query??? next one doesn't handle ties

SELECT DISTINCT TOP 1 ([Current Team]), COUNT([Player Name]) c
	FROM Basic_Stats
	WHERE [Current Team] <> ''
	GROUP BY [Current Team] 
	ORDER BY c DESC;

-- How many  player has a Active status in the team?
SELECT COUNT([Player Id])
  FROM Basic_Stats
  WHERE [Current Status] = 'Active';

SELECT * FROM Basic_Stats;
SELECT * FROM Career_Stats_Defensive;

SELECT Team,
  SUM(CAST([Games Played] as int)) as 'Total Games Played'
  FROM Career_Stats_Defensive
  GROUP BY [Games Played], Team;

SELECT [Games Played], Team
 FROM Career_Stats_Defensive
 ORDER BY Team

SELECT COUNT(
  DISTINCT Team)
  FROM Career_Stats_Defensive

SELECT DISTINCT Team
  FROM Career_Stats_Defensive
  Order by Team;

SELECT 
  SUM(CAST([Games Played] as int)) 'Games Played'
  FROM Career_Stats_Defensive
  GROUP BY Team, [Games Played]
  order by Team, [Games Played];

SELECT Team,
  SUM(CAST([Games Played] as int)) 'Games Played'
  FROM Career_Stats_Defensive
  GROUP BY Team
  order by Team;

-- List Player Name whose current status is "Active" and their Playing Position is "OLB".
SELECT [Player Name], Position
  FROM Basic_Stats
  WHERE [Current Status] = 'Active' AND Position = 'OLB';

-- How many players attended college at Texas A&M?

SELECT COUNT([Player Id])
  FROM Basic_Stats
  WHERE College = 'Texas A&M';

-- List player names with a current status as "Active", have played for greater than 3 seasons?
SELECT DISTINCT c.[Player Name],
	COUNT(Season) [# of Seasons]
  FROM Career_Stats_Defensive c JOIN Basic_Stats b
    ON c.[Player Id] = b.[Player Id]
  WHERE [Current Status] = 'Active'
  GROUP BY c.[Player Name]
  HAVING COUNT(Season) >= 3
  ORDER BY [# of Seasons] DESC;

SELECT COUNT(DISTINCT Season)
  FROM Career_Stats_Defensive;

SELECT DISTINCT Season
  FROM Career_Stats_Defensive;

SELECT COUNT([Player Id])
  FROM Basic_Stats
  WHERE [Current Status] = 'Active';

SELECT COUNT(DISTINCT Season)
  FROM Career_Stats_Defensive;