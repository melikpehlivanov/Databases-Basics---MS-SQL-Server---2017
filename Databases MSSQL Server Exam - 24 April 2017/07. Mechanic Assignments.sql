SELECT CONCAT(FirstName, ' ', LastName) AS Mechanic, j.Status, j.IssueDate FROM Mechanics AS m
JOIN Jobs AS j ON j.MechanicId = m.MechanicId
ORDER BY m.MechanicId, J.IssueDate, j.JobId