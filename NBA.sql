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

-- Which team wins the most at home
select top 1 Team, count(Win) as Wins_Home
from champions
where Home = '1' and Win = '1'
group by team
order by count(Win) desc;

-- Which team wins the most away
select top 1 Team, count(Win) as Wins_Away
from champions
where Home = '0' and Win = '1'
group by team
order by count(Win) desc;