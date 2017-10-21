CREATE TRIGGER tr_Messages ON Messages AFTER DELETE
AS
BEGIN
	INSERT INTO MessageLogs(Id, Content, SentOn, ChatId, UserId)
	SELECT Id, Content, SentOn, ChatId, UserId FROM deleted
END