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