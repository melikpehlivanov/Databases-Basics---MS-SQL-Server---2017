SELECT 
  j.JobId,
  ISNULL(SUM(p.Price * op.Quantity),0) AS [Total] 
  FROM Parts AS P
FULL JOIN OrderParts AS op ON p.PartId = op.PartId
FULL JOIN Orders AS o ON op.OrderId = o.OrderId
FULL JOIN Jobs AS j ON o.JobId = j.JobId
WHERE j.STATUS = 'Finished'
GROUP BY j.JobId
ORDER BY [Total] DESC, j.JobId