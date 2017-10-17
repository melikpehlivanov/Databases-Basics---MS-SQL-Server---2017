SELECT CONCAT(FirstName, ' ', LastName) AS Client,
DATEDIFF(DAY, j.IssueDate, '20170424') AS 'Days Going',
j.Status 
FROM Clients AS c
JOIN Jobs AS j ON j.ClientId = c.ClientId
WHERE j.Status != 'Finished'
ORDER BY [Days Going] DESC, c.ClientId ASC