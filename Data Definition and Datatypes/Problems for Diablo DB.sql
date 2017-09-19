--12.
SELECT TOP(50) Name, FORMAT(Start, 'yyyy-MM-dd') AS 'Start' FROM Games
WHERE YEAR(Games.Start) BETWEEN 2011 AND 2012
ORDER BY Games.Start,Name

--13.
SELECT Username, RIGHT(Email, LEN(Email) - CHARINDEX('@',Email)) AS 'Email Provider' FROM Users
ORDER BY [Email Provider], Username

--14.
SELECT Username, IpAddress FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

--15.
Select G.Name as Game,
Case 
When DATEPART(HOUR,G.Start) Between 0 and 11 Then 'Morning'
When DATEPART(HOUR,G.Start) Between 12 and 17 Then 'Afternoon'
When DATEPART(HOUR,G.Start) Between 18 and 23 Then 'Evening'
END AS [Part of the Day],
Case
When G.Duration <=3 THEN 'Extra Short'
When G.Duration Between 4 AND 6 THEN 'Short'
When G.Duration >6 THEN 'Long'
ELSE 'Extra Long'
END as [Duration]
from Games as G
Order BY G.Name,
[Duration],
[Part of the Day]


