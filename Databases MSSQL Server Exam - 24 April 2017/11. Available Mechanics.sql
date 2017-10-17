SELECT 
	CONCAT(m.FirstName, ' ', m.LastName) AS Available
FROM Mechanics AS m
JOIN
(SELECT * FROM Mechanics
WHERE MechanicId NOT IN (
SELECT MechanicId FROM Jobs
WHERE STATUS <> 'Finished' 
AND MechanicId IS NOT NULL)) AS s ON s.MechanicId = m.MechanicId