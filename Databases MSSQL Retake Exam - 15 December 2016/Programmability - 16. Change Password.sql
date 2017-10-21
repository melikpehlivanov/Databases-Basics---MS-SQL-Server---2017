CREATE PROC udp_ChangePassword(@Email VARCHAR(MAX), @NewPassword VARCHAR(MAX))
AS
BEGIN
	BEGIN TRAN
	UPDATE Credentials
	SET Password = @NewPassword
	WHERE Email = @Email

	IF(@@ROWCOUNT <> 1)
	BEGIN
		ROLLBACK;
		RAISERROR('The email does''t exist!', 16, 1)
	END

	ELSE
	BEGIN
		COMMIT;
	END
END