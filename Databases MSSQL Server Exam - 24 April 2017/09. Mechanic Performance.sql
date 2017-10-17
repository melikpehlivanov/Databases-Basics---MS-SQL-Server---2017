SELECT CONCAT(FirstName, ' ', LastName) AS Mechanic, a.AVGDays AS AverageDays
FROM Mechanics AS m
JOIN 
(SELECT m.MechanicId AS 'Mechanic', avg(datediff(day, j.IssueDate, j.FinishDate)) AS 'AVGDays' FROM Jobs AS j
 JOIN Mechanics AS m ON m.MechanicId = j.MechanicId
 WHERE STATUS = 'Finished'
 GROUP BY m.MechanicId) AS a ON m.MechanicId = a.Mechanic 