SELECT TOP 15 school, conference, song_name, year
  FROM [fight-songs]
  ORDER BY year DESC;

-- Select all the data for schools with fight songs written in 1950 or later.
-- Sort results from youngest to oldest.  Exclude songs with unknown year written.
SELECT * 
  FROM [fight-songs]
  WHERE year > '1949'
    AND year <> 'unknown';

-- Which song as slowest bpm
SELECT TOP 1 school, song_name, bpm
  FROM [fight-songs]
  ORDER BY bpm DESC;

-- Which song as fastest bpm
SELECT TOP 1 school, song_name, bpm
  FROM [fight-songs]
  ORDER BY bpm ASC;