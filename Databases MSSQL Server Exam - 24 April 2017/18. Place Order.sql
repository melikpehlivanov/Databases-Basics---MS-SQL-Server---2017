CREATE PROC usp_PlaceOrder @JobId INT, @SerialNumber VARCHAR(50), @Quantity INT
AS
BEGIN
	IF(@Quantity <=0)
	BEGIN
		RAISERROR('Part quantity must be more than zero!', 16, 1)
		RETURN;
	END

	DECLARE @JobIdSelect INT = (SELECT JobId FROM Jobs WHERE JobId = @JobId)

	IF(@JobIdSelect IS NULL)
	BEGIN
		RAISERROR('Job not found!', 16, 1)
	END

	DECLARE @JobStatus VARCHAR(50) = (SELECT Status FROM Jobs WHERE JobId = @JobId)
	IF(@JobStatus = 'Finished')
	BEGIN
		RAISERROR('This job is not active!', 16, 1)
	END

	DECLARE @PartId INT = (SELECT PartId FROM Parts WHERE SerialNumber = @SerialNumber)
	IF(@PartId IS NULL)
	BEGIN
		RAISERROR('Part not found!', 16, 1)
		RETURN;
	END

	DECLARE @OrderId INT = (SELECT o.OrderId FROM Orders AS o
							JOIN OrderParts AS op ON op.OrderId = o.OrderId
							JOIN Parts AS p ON p.PartId = op.PartId
							WHERE JobId = @JobId AND p.PartId = @PartId AND IssueDate IS NULL)
	
	IF(@OrderId IS NULL)
	BEGIN
	INSERT INTO Orders(JobId, IssueDate) VALUES
	(@JobId, NULL)

	INSERT INTO OrderParts(OrderId, PartId, Quantity) VALUES
	(IDENT_CURRENT('Orders'), @PartId, @Quantity)
	END

	ELSE
	BEGIN
		DECLARE @PartExistanceOrder INT = (SELECT @@ROWCOUNT FROM OrderParts WHERE OrderId = @OrderId AND PartId = @PartId)

		IF(@PartExistanceOrder IS NULL)
		BEGIN
			INSERT INTO OrderParts(OrderId, PartId, Quantity) VALUES
			(@OrderId, @PartId, @Quantity)
		END

		ELSE
		BEGIN
			UPDATE OrderParts
			SET Quantity += @Quantity
			WHERE OrderId = @OrderId AND PartId = @PartId
		END
	END
END