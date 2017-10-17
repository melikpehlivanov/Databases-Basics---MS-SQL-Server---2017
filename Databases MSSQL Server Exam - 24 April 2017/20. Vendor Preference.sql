WITH CTE_Parts
AS
(
	SELECT m.MechanicId,
		   v.VendorId,
		   SUM(op.Quantity) AS VendorItems
	 FROM Mechanics AS m
	JOIN Jobs AS j ON j.MechanicId = m.MechanicId
	JOIN Orders AS o ON o.JobId = j.JobId
	JOIN OrderParts AS op ON op.OrderId = o.OrderId
	JOIN Parts AS p ON p.PartId = op.PartId
	JOIN Vendors AS v ON v.VendorId = P.VendorId
	GROUP BY m.MechanicId, v.VendorId
)

SELECT CONCAT(m.FirstName, ' ', m.LastName) AS [Mechanic],
	   v.Name AS [Vendor],
	   c.VendorItems AS [Parts],
	   CAST(CAST(CAST(VendorItems AS DECIMAL(6,2)) / (SELECT SUM(VendorItems) FROM CTE_Parts WHERE MechanicId = c.MechanicId) * 100 AS INT) AS VARCHAR(MAX)) + '%' AS Preference
	FROM CTE_Parts AS c
JOIN Mechanics AS m ON m.MechanicId = c.MechanicId
JOIN Vendors AS v ON v.VendorId = c.VendorId
ORDER BY Mechanic, Parts DESC, Vendor