CREATE PROC udp_SendMessage(@UserId INT, @ChatId INT, @Content VARCHAR(MAX))
AS
BEGIN
	DECLARE @UserExists INT = (SELECT COUNT(*) FROM Messages WHERE UserId = @UserId AND ChatId = @ChatId)
	
	BEGIN TRAN
	IF(@UserExists = 0)
	BEGIN
		ROLLBACK;
		RAISERROR('There is no chat with that user!', 16, 1);
		RETURN
	END

	INSERT INTO Messages(Content, SentOn, ChatId, UserId)
	VALUES(@Content, GETDATE(), @ChatId, @UserId)

	COMMIT;
END