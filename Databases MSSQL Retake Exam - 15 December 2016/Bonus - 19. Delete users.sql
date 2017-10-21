CREATE TRIGGER tr_Deleting_Users ON Users INSTEAD OF DELETE
AS
BEGIN
	DELETE FROM UsersChats
	WHERE UserId = (SELECT Id from deleted)

	DELETE FROM Messages
	WHERE UserId = (SELECT Id from deleted)

	DELETE FROM Users
	WHERE Id = (SELECT Id from deleted)
END