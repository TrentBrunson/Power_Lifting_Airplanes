SELECT DISTINCT l.LifterName, l.Sex
  FROM lifters l JOIN meets m
    ON l.MeetID = m.MeetID
  WHERE m.MeetCountry = 'Wales';

-- What countries are included in the meets database? Sort alphabetically by country name. (single table)
SELECT DISTINCT MeetCountry
  FROM meets
  ORDER BY MeetCountry;

-- Select the MeetID, LifterName, Sex, Age, TotalKg for the top 25 lifters by most weight lifted. (single table)
SELECT TOP 25 MeetID, LifterName, Sex, Age, TotalKg
  FROM lifters
  ORDER BY TotalKg DESC;

-- Modify the previous query to include meet date and meet location.
SELECT TOP 25 l.MeetID, LifterName, Sex, Age, TotalKg
  FROM lifters l JOIN meets m
    ON l.MeetID = m.MeetID
  ORDER BY TotalKg DESC;

-- List the names and sex for each distinct lifter that lifted in a meet in Wales.
SELECT DISTINCT l.LifterName, l.Sex
  FROM lifters l JOIN meets m
    ON l.MeetID = m.MeetID
  WHERE m.MeetCountry = 'Wales';

-- List all of the countries where Andy Cusick competed in meets. Sort results by country name. Your result should only list each country once.
SELECT DISTINCT m.MeetCountry
  FROM lifters l JOIN meets m
    ON l.MeetID = m.MeetID
  WHERE l.LifterName = 'Andy Cusick'
    ORDER BY m.MeetCountry ;

-- How many distinct places (e.g., what place did the lifter finish in the final meet standings?) are included in the lifters table. 
-- HINT: do not use a summary query. Just visually scan result set. (single table)
SELECT DISTINCT Place
  FROM lifters
  ORDER BY 1;
  -- cast this as integer???