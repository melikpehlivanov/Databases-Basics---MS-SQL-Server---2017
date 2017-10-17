SELECT TOP 3 
	CONCAT(FirstName, ' ', LastName) AS Mechanic ,
	COUNT(j.Status) AS Jobs
FROM Mechanics AS m
JOIN Jobs AS j ON J.MechanicId = M.MechanicId
WHERE j.Status != 'Finished'
GROUP BY CONCAT(FirstName, ' ', LastName)
HAVING (COUNT(j.Status) > 1)
ORDER BY Jobs DESC