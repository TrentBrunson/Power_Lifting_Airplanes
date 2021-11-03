SELECT DISTINCT l.LifterName, l.Sex
FROM lifters as l JOIN meets as m
	ON l.MeetID = m.MeetID
WHERE m.MeetCountry = 'Wales';
