SELECT TOP 1 WITH TIES m.Name, COUNT(*) AS [Times Serviced],
(SELECT ISNULL(SUM(p.Price * op.Quantity),0) FROM Jobs AS j
JOIN Orders AS o ON O.JobId = j.JobId
JOIN OrderParts AS op ON op.OrderId = o.OrderId
JOIN Parts AS p ON p.[PartId] = op.PartId
WHERE j.ModelId = m.ModelId) AS [Parts Total]
 FROM Models AS m
JOIN Jobs AS j ON j.ModelId = m.ModelId
GROUP BY m.ModelId, m.Name
ORDER BY [Times Serviced] DESC