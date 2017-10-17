SELECT 
	ISNULL(SUM(p.Price * op.Quantity),0) AS [Parts Total] 
FROM Parts AS P
JOIN OrderParts AS op ON op.PartId = p.PartId
JOIN Orders AS o ON o.OrderId = op.OrderId
WHERE o.IssueDate > (DATEADD(WEEK, -3 , '2017/04/24'))