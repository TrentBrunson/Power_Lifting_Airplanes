SELECT TOP 25 FGA 
  FROM champions ch;

SELECT *
  FROM runnerup ru
  WHERE TPP = '0' or TPP = 'NA';

SELECT ch.PTS, ru.PTS
  FROM champions ch JOIN runnerup ru
    ON ch.Team = ru.Team
  WHERE ru.FGA > ch.FGA;

SELECT ch.Year, ch.Game, ch.Team, ch.PTS, ru.Team, ru.PTS
  FROM champions ch JOIN runnerup ru
    ON ch.Year = ru.Year and ch.Game = ru.Game;