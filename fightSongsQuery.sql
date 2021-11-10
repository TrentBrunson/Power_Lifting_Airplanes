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

-- List the spotify ids for schools in the Big Ten.
select school,  
       spotify_id 
from [fight-songs]
where conference = 'Big Ten';

--  What is the longest song with slowest BPM?
SELECT TOP(1) [song_name], [bpm],[sec_duration]
    FROM [fight-songs]
    ORDER BY sec_duration DESC;

-- How many songs with yes in nonsense, number of fights greater than 5 and were written by a student?
SELECT school, song_name, nonsense, student_writer, number_fights
FROM [fight-songs]
WHERE nonsense = 'Yes' AND number_fights >= '5' AND student_writer = 'Yes';
