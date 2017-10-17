CREATE FUNCTION udf_GetCost (@JobId INT)
RETURNS DECIMAL(6,2)
AS
BEGIN
	DECLARE @TotalSum DECIMAL(6,2) = 
(SELECT ISNULL(SUM(p.Price * op.Quantity),0) FROM Parts AS p
JOIN OrderParts AS op ON op.PartId = p.PartId
JOIN Orders AS o ON o.OrderId = op.OrderId
JOIN Jobs AS j ON j.JobId = o.JobId
WHERE j.JobId = @JobId)

RETURN @TotalSum

END
