--01. Record's Count
SELECT COUNT (Id) AS 'Count' FROM WizzardDeposits

--02. Longest Magic Wand
SELECT MAX(MagicWandSize) AS [LongestMagicWand] FROM WizzardDeposits

--03. Longest Magic Wand per Deposit Groups
SELECT DepositGroup, MAX(MagicWandSize) AS [LongestMagicWand] FROM WizzardDeposits
GROUP BY DepositGroup

--04. *Smallest Deposit Group per Magic Wand Size

--First Way
SELECT DepositGroup FROM WizzardDeposits
GROUP BY DepositGroup
HAVING AVG(MagicWandSize)= (
			     SELECT Min(WizzardWandSizes.AverageMagicWandSize) FROM (
		             SELECT DepositGroup, AVG(MagicWandSize) AS AverageMagicWandSize FROM WizzardDeposits
			     GROUP BY DepositGroup
			   ) AS [WizzardWandSizes]
			 )

--Second Way 
SELECT TOP 1 WITH TIES DepositGroup FROM WizzardDeposits
GROUP BY DepositGroup
ORDER BY AVG(MagicWandSize)

--05. Deposits Sum
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
GROUP BY DepositGroup

--06. Deposits Sum For Ollivander Family
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
WHERE MagicWandCreator='Ollivander family'
GROUP BY DepositGroup

--07. Deposits Filter
SELECT DepositGroup, SUM(DepositAmount) AS TotalSum FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family' 
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY TotalSum DESC

--08. Deposit Charge
SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS MinDepositCharge FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator, DepositGroup
				
--09. Age Groups	
SELECT ageGroups.AgeGroup, COUNT(*) FROM
(
SELECT 
CASE
WHEN Age BETWEEN 0 AND 10 THEN '[0-10]'
WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
WHEN Age BETWEEN 41 AND 50 THEN '[41-50]'
WHEN Age BETWEEN 51 AND 60 THEN '[51-60]'
WHEN Age >= 61 THEN '[61+]'
END AS AgeGroup
FROM WizzardDeposits
) AS ageGroups
GROUP BY ageGroups.AgeGroup

--10. First Letter
SELECT DISTINCT LEFT(FirstName, 1) AS FirstLetter
FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
ORDER BY FirstLetter	  

--11. Average Interest
SELECT DepositGroup, IsDepositExpired, AVG(DepositInterest) AS AverageInterest
FROM WizzardDeposits
WHERE DepositStartDate > '1985/01/01'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired

--12. 
SELECT SUM(wizardDeposit.Difference) AS SumDifference FROM
(
SELECT FirstName, DepositAmount,
LEAD(FirstName) OVER (ORDER BY Id) AS GuestWizard,
LEAD(DepositAmount) OVER (ORDER BY Id) AS GuestDeposit,
DepositAmount - LEAD(DepositAmount) OVER (ORDER BY Id) AS Difference 
FROM WizzardDeposits
) AS wizardDeposit

--13. Departments Total Salaries
USE SoftUni -- DO NOT submit in the judge system Use SoftUni statement or you will get compile time error.
SELECT   DepartmentID, SUM(Salary) AS TotalSalary FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

--14. Employees Minimum Salaries
SELECT DepartmentID, MIN(Salary) AS MinimumSalary
FROM Employees
WHERE DepartmentID IN (2,5,7) AND HireDate > '2000/01/01'
GROUP BY DepartmentID

--15 Employees Average Salaries
SELECT * INTO NewTable FROM Employees
WHERE Salary > 30000

DELETE FROM NewTable
WHERE ManagerId = 42

UPDATE NewTable
SET Salary += 5000
WHERE DepartmentID = 1
SELECT DepartmentID, AVG(Salary) AS AverageSalary FROM NewTable
GROUP BY DepartmentID

--16. Employees Maximum Salaries
SELECT DepartmentID, MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) NOT BETWEEN 30000 AND 70000

--17. Employees Count Salaries
SELECT COUNT(Salary) AS Count FROM Employees
WHERE ManagerID IS NULL

--18. 3rd-Highest Salary
USE SoftUni -- DO NOT submit in the judge system Use SoftUni statement or you will get compile time error.
SELECT Salaries.DepartmentID, Salaries.Salary FROM
(
SELECT DepartmentId,
MAX(Salary) AS Salary,
DENSE_RANK() OVER (PARTITION BY DepartmentId ORDER BY Salary DESC) AS Rank
FROM Employees
GROUP BY DepartmentID, Salary
)AS Salaries 
WHERE Rank=3

--19. Salary Challenge
SELECT TOP 10 FirstName, LastName, DepartmentID FROM Employees AS emp1
WHERE Salary >
(SELECT AVG(Salary) FROM Employees AS emp2
WHERE emp1.DepartmentID = emp2.DepartmentID
GROUP BY DepartmentID)
ORDER BY DepartmentID
