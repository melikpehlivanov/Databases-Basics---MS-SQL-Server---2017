-- 01. Create Table Logs
CREATE TRIGGER tr_AccountBalanceChange ON Accounts FOR UPDATE
AS
BEGIN
  DECLARE @accountId int = (SELECT Id FROM inserted);
  DECLARE @oldBalance money = (SELECT Balance FROM deleted);
  DECLARE @newBalance money = (SELECT Balance FROM inserted);

  IF(@newBalance <> @oldBalance)
    INSERT INTO Logs VALUES (@accountId, @oldBalance, @newBalance);
END

-- 02. Create Table Emails
CREATE TRIGGER tr_LogsNotificationEmails ON Logs FOR INSERT
AS
BEGIN

  DECLARE @recipient int = (SELECT AccountId FROM inserted);
  DECLARE @oldBalance money = (SELECT OldSum FROM inserted);
  DECLARE @newBalance money = (SELECT NewSum FROM inserted);
  DECLARE @subject varchar(200) = CONCAT('Balance change for account: ', @recipient);
  DECLARE @body varchar(200) = CONCAT('On ', GETDATE(), ' your balance was changed from ', @oldBalance, ' to ', @newBalance, '.');  

  INSERT INTO NotificationEmails (Recipient, Subject, Body) 
  VALUES (@recipient, @subject, @body)
END

--03. Deposit Money
CREATE PROC usp_DepositMoney (@accountId int, @depositAmount money)
AS
BEGIN
  BEGIN TRANSACTION
  UPDATE Accounts
  SET Balance += @depositAmount
  WHERE (Id = @accountId)

  IF (@@ROWCOUNT <> 1) 
    BEGIN
      ROLLBACK;
      RAISERROR ('Invalid account!', 16, 1);
      RETURN;
    END

  COMMIT;

END

--04. Withdraw Money Procedure
CREATE PROCEDURE usp_WithdrawMoney (@accountId int, @withdrawAmount money)
AS
BEGIN
  BEGIN TRANSACTION
  UPDATE Accounts
  SET Balance -= @withdrawAmount
  WHERE Id = @accountId

  IF (@@ROWCOUNT <> 1)
  BEGIN
    ROLLBACK;
	RAISERROR ('Invalid account!', 16, 1);
	RETURN;
  END

  COMMIT;

END

--05. Money Transfer
CREATE PROCEDURE usp_TransferMoney (@senderId int, @receiverId int, @transferAmount money)
AS
BEGIN 

  DECLARE @senderBalanceBefore money = (SELECT Balance FROM Accounts WHERE Id = @senderId);

  IF(@senderBalanceBefore IS NULL)
  BEGIN
    RAISERROR('Invalid sender account!', 16, 1);
    RETURN;

  END   

  DECLARE @receiverBalanceBefore money = (SELECT Balance FROM Accounts WHERE Id = @receiverId);  

  IF(@receiverBalanceBefore IS NULL)
  BEGIN
    RAISERROR('Invalid receiver account!', 16, 1);
    RETURN;
  END   

  IF(@senderId = @receiverId)
  BEGIN
    RAISERROR('Sender and receiver accounts must be different!', 16, 1);
    RETURN;
  END  

  IF(@transferAmount <= 0)
  BEGIN
    RAISERROR ('Transfer amount must be positive!', 16, 1); 
    RETURN;

  END 

  BEGIN TRANSACTION
  EXEC usp_WithdrawMoney @senderId, @transferAmount;
  EXEC usp_DepositMoney @receiverId, @transferAmount;

  DECLARE @senderBalanceAfter money = (SELECT Balance FROM Accounts WHERE Id = @senderId);
  DECLARE @receiverBalanceAfter money = (SELECT Balance FROM Accounts WHERE Id = @receiverId);  

  IF((@senderBalanceAfter <> @senderBalanceBefore - @transferAmount) OR 
     (@receiverBalanceAfter <> @receiverBalanceBefore + @transferAmount))
    BEGIN
      ROLLBACK;
      RAISERROR('Invalid account balances!', 16, 1);
      RETURN;
    END

  COMMIT;

END

--07. *Massive Shopping
DECLARE @gameName nvarchar(50) = 'Safflower';
DECLARE @username nvarchar(50) = 'Stamat';

DECLARE @userGameId int = (
  SELECT ug.Id 
  FROM UsersGames AS ug
  JOIN Users AS u ON ug.UserId = u.Id
  JOIN Games AS g ON ug.GameId = g.Id
  WHERE u.Username = @username AND g.Name = @gameName

);

DECLARE @userGameLevel int = (SELECT Level FROM UsersGames WHERE Id = @userGameId);
DECLARE @itemsCost money, @availableCash money, @minLevel int, @maxLevel int;



-- Buy items from LEVEL 11-12
SET @minLevel = 11; SET @maxLevel = 12;
SET @availableCash = (SELECT Cash FROM UsersGames WHERE Id = @userGameId);
SET @itemsCost = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel);



/* begin transaction only if: enough game cash to buy all requested items & 

   high enough user game level to meet item minlevel requirement */

IF (@availableCash >= @itemsCost AND @userGameLevel >= @maxLevel) 

BEGIN 
  BEGIN TRANSACTION  
  UPDATE UsersGames SET Cash -= @itemsCost WHERE Id = @userGameId; 
  IF(@@ROWCOUNT <> 1) 
  BEGIN
    ROLLBACK; RAISERROR('Could not make payment', 16, 1); --RETURN;
  END

  ELSE
  BEGIN

    INSERT INTO UserGameItems (ItemId, UserGameId) 
    (SELECT Id, @userGameId FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) 

    IF((SELECT COUNT(*) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) <> @@ROWCOUNT)
    BEGIN
      ROLLBACK; RAISERROR('Could not buy items', 16, 1); --RETURN;
    END	

    ELSE COMMIT;

  END

END



-- Buy items from LEVEL 19-21
SET @minLevel = 19; SET @maxLevel = 21;
SET @availableCash = (SELECT Cash FROM UsersGames WHERE Id = @userGameId);
SET @itemsCost = (SELECT SUM(Price) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel);

/* begin transaction only if: enough game cash to buy all requested items & 

   high enough user game level to meet item minlevel requirement */

IF (@availableCash >= @itemsCost AND @userGameLevel >= @maxLevel) 

BEGIN 
  BEGIN TRANSACTION  
  UPDATE UsersGames SET Cash -= @itemsCost WHERE Id = @userGameId; 

  IF(@@ROWCOUNT <> 1) 
  BEGIN
    ROLLBACK; RAISERROR('Could not make payment', 16, 1); --RETURN;
  END

  ELSE
  BEGIN

    INSERT INTO UserGameItems (ItemId, UserGameId) 
    (SELECT Id, @userGameId FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) 

    IF((SELECT COUNT(*) FROM Items WHERE MinLevel BETWEEN @minLevel AND @maxLevel) <> @@ROWCOUNT)
    BEGIN
      ROLLBACK; RAISERROR('Could not buy items', 16, 1); --RETURN;
    END	

    ELSE COMMIT;
  END

END

-- select items in game
SELECT i.Name AS [Item Name]
FROM UserGameItems AS ugi
JOIN Items AS i ON i.Id = ugi.ItemId
JOIN UsersGames AS ug ON ug.Id = ugi.UserGameId
JOIN Games AS g ON g.Id = ug.GameId
WHERE g.Name = @gameName
ORDER BY [Item Name]


--08. Employees with Three Projects
CREATE PROCEDURE usp_AssignProject (@employeeID int, @projectID int)
AS
BEGIN

  DECLARE @maxEmployeeProjectsCount int = 3;
  DECLARE @employeeProjectsCount int;

  BEGIN TRAN
  INSERT INTO EmployeesProjects (EmployeeID, ProjectID) 
  VALUES (@employeeID, @projectID)

  SET @employeeProjectsCount = (
    SELECT COUNT(*)
    FROM EmployeesProjects
    WHERE EmployeeID = @employeeID

  )

  IF(@employeeProjectsCount > @maxEmployeeProjectsCount)

    BEGIN
      RAISERROR('The employee has too many projects!', 16, 1);
      ROLLBACK;
    END

  ELSE COMMIT

END
