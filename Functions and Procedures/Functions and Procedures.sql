USE SoftUni -- DO NOT SUBMIT THIS STATEMENT IN THE JUDGE SYSTEM OR YOU WILL GET COMPILE TIME ERROR.

--01. Employees with Salary Above 35000
GO -- DO NOT SUBMIT IN JUDGE "Go"
CREATE PROCEDURE usp_GetEmployeesSalaryAbove35000
AS
SELECT FirstName, LastName FROM Employees
WHERE Salary > 35000
--02. Employees with Salary Above Number
GO  -- DO NOT SUBMIT IN JUDGE "Go"
CREATE PROCEDURE usp_GetEmployeesSalaryAboveNumber (@Salary MONEY)
AS 
SELECT FirstName, LastName FROM Employees
WHERE Salary>=@Salary
--Testing DO NOT SUBMIT IN JUDGE

EXEC usp_GetEmployeesSalaryAboveNumber 50000;

--03. Town Names Starting With
GO  -- DO NOT SUBMIT IN JUDGE "Go"
CREATE PROCEDURE usp_GetTownsStartingWith (@STRING NVARCHAR(MAX))
AS
SELECT Name AS Town FROM Towns
WHERE Name LIKE CONCAT(@STRING, '%')

--Testing DO NOT SUBMIT IN JUDGE
EXEC usp_GetTownsStartingWith 'b'

--04. Employees from Town
GO  -- DO NOT SUBMIT IN JUDGE "Go"
CREATE PROCEDURE usp_GetEmployeesFromTown (@TownName NVARCHAR(50))
AS
SELECT e.FirstName, e.LastName FROM Employees AS e
JOIN Addresses AS a ON a.AddressID=e.AddressID
JOIN Towns AS t ON t.TownID = a.TownID
WHERE @TownName = t.Name

--Testing DO NOT SUBMIT IN JUDGE
EXEC usp_GetEmployeesFromTown 'Sofia'

--05. Salary Level Function
GO  -- DO NOT SUBMIT IN JUDGE "Go"
CREATE FUNCTION ufn_GetSalaryLevel(@Salary MONEY)
RETURNS nvarchar(10)
BEGIN
	DECLARE @SalaryLevel NVARCHAR(10);
	IF(@Salary<30000) SET @SalaryLevel = 'Low' ;
	ELSE IF(@Salary BETWEEN 30000 AND 50000) SET @SalaryLevel = 'Average';
	ELSE SET @SalaryLevel = 'High';

	RETURN @SalaryLevel;
END

--Testing DO NOT SUBMIT IN JUDGE
SELECT Salary, dbo.ufn_GetSalaryLevel(Salary) AS 'Salary Level'
FROM Employees
ORDER BY Salary
DESC

--06. Employees by Salary Level
GO  -- DO NOT SUBMIT IN JUDGE "Go"
CREATE PROCEDURE usp_EmployeesBySalaryLevel(@SalaryLevel VARCHAR(10))
AS
SELECT FirstName, LastName FROM Employees
WHERE dbo.ufn_GetSalaryLevel(Salary) = @SalaryLevel

--Testing DO NOT SUBMIT IN JUDGE
EXEC dbo.usp_EmployeesBySalaryLevel 'High'

--07. Define Function
GO  -- DO NOT SUBMIT IN JUDGE "Go"
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters VARCHAR(max), @word VARCHAR(max))
RETURNS BIT
AS
BEGIN
  DECLARE @isComprised BIT = 0;
  DECLARE @currentIndex INT = 1;
  DECLARE @currentChar CHAR;

  WHILE(@currentIndex <= LEN(@word))
  BEGIN

    SET @currentChar = SUBSTRING(@word, @currentIndex, 1);
    IF(CHARINDEX(@currentChar, @setOfLetters) = 0)
      RETURN @isComprised;
    SET @currentIndex += 1;

  END

  RETURN @isComprised + 1;

END


--testing - do not Submit in Judge

CREATE TABLE Testing (SetOfLetters varchar(max), Word varchar(max))
GO  -- DO NOT SUBMIT IN JUDGE "Go"

INSERT INTO Testing VALUES 
  ('oistmiahf', 'Sofia'), ('oistmiahf', 'halves'), ('bobr', 'Rob'), ('pppp', 'Guy')
GO  -- DO NOT SUBMIT IN JUDGE "Go"

SELECT SetOfLetters, Word,
  dbo.ufn_IsWordComprised(SetOfLetters, Word) AS Result
FROM Testing
--08. * Delete Employees and Departments
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
ALTER TABLE Departments
ALTER COLUMN ManagerID INT NULL

DELETE FROM EmployeesProjects
WHERE EmployeeID IN (
						SELECT EmployeeID FROM Employees
						WHERE DepartmentID = @departmentId
					)

UPDATE Employees
SET ManagerID = NULL
WHERE ManagerID IN (
						SELECT EmployeeID FROM Employees
						WHERE DepartmentID = @departmentId
				   )


UPDATE Departments
SET ManagerID = NULL
WHERE ManagerID IN (
						SELECT EmployeeID FROM Employees
						WHERE DepartmentID = @departmentId
				   )

DELETE FROM Employees
WHERE EmployeeID IN (
						SELECT EmployeeID FROM Employees
						WHERE DepartmentID = @departmentId
				    )

DELETE FROM Departments
WHERE DepartmentID = @departmentId
SELECT COUNT(*) AS [Employees Count] FROM Employees AS e
JOIN Departments AS d
ON d.DepartmentID = e.DepartmentID
WHERE e.DepartmentID = @departmentId

--9. Find Full Name
GO  -- DO NOT SUBMIT IN JUDGE "Go" 
USE Bank -- DO NOT SUBMIT IN JUDGE the USE Bank statement or you will get compile time error.
GO  -- DO NOT SUBMIT IN JUDGE "Go"
CREATE PROC usp_GetHoldersFullName
AS
  SELECT CONCAT(FirstName, ' ', LastName) AS [Full Name]
  FROM AccountHolders

--testing - do not Submit in Judge
EXEC usp_GetHoldersFullName

--10. People with Balance Higher Than
GO  -- DO NOT SUBMIT IN JUDGE "Go"
CREATE PROC usp_GetHoldersWithBalanceHigherThan (@minBalance money)
AS
BEGIN
  WITH CTE_MinBalanceAccountHolders (HolderId) AS (
    SELECT AccountHolderId FROM Accounts
    GROUP BY AccountHolderId
    HAVING SUM(Balance) > @minBalance
  )

  SELECT ah.FirstName AS [First Name], ah.LastName AS [Last Name]
  FROM CTE_MinBalanceAccountHolders AS minBalanceHolders 
  JOIN AccountHolders AS ah ON ah.Id = minBalanceHolders.HolderId
  ORDER BY ah.LastName, ah.FirstName 

END

-- testing - do not submit in Judge
EXEC usp_GetHoldersWithBalanceHigherThan 6000000;
EXEC usp_GetHoldersWithBalanceHigherThan 5000000;
EXEC usp_GetHoldersWithBalanceHigherThan 1000;

--11. Future Value Function
GO -- DO NOT SUBMIT IN JUDGE "Go"
USE Bank -- DO NOT SUBMIT IN JUDGE the USE Bank statement or you will get compile time error.
CREATE FUNCTION ufn_CalculateFutureValue (@sum money, @annualIntRate float, @years int)
RETURNS money
AS
BEGIN

  RETURN @sum * POWER(1 + @annualIntRate, @years);  

END;

-- testing - do not submit in Judge
SELECT dbo.ufn_CalculateFutureValue(1000, 0.10, 5) AS FV

--12. Calculating Interest
GO -- DO NOT SUBMIT IN JUDGE "Go"
CREATE PROC usp_CalculateFutureValueForAccount (@accountId int, @interestRate float)
AS
BEGIN
  DECLARE @years int = 5;

  SELECT
    a.Id AS [Account Id],
    ah.FirstName AS [First Name],
    ah.LastName AS [Last Name], 
    a.Balance AS [Current Balance],
    dbo.ufn_CalculateFutureValue(a.Balance, @interestRate, @years) AS [Balance in 5 years]
  FROM AccountHolders AS ah
  JOIN Accounts AS a ON ah.Id = a.AccountHolderId
  WHERE a.Id = @accountId

END

--Testing DO NOT submit in judge
EXEC usp_CalculateFutureValueForAccount 1, 0.10;

--13. *Cash in User Games Odd Rows
GO --DO NOT SUBMIT IN JUDGE "Go"
USE Diablo --DO NOT SUBMIT IN JUDGE the USE Diablo statement or you will get compile time error.
CREATE FUNCTION ufn_CashInUsersGames (@gameName nvarchar(50))
RETURNS table
AS
RETURN (
  WITH CTE_CashInRows (Cash, RowNumber) AS (
    SELECT ug.Cash, ROW_NUMBER() OVER (ORDER BY ug.Cash DESC)
    FROM UsersGames AS ug
    JOIN Games AS g ON ug.GameId = g.Id
    WHERE g.Name = @gameName
  )
  SELECT SUM(Cash) AS SumCash
  FROM CTE_CashInRows
  WHERE RowNumber % 2 = 1 -- odd row numbers only

)

-- testing
SELECT * FROM dbo.ufn_CashInUsersGames ('Lily Stargazer');
SELECT * FROM dbo.ufn_CashInUsersGames ('Love in a mist');
