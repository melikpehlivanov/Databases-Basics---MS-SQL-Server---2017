 --01. Find Names of All Employees by First Name 
USE SoftUni -- DO NOT submit in the judge system Use SoftUni statement in judge or you will get compile time error.
SELECT FirstName, LastName FROM Employees 
WHERE FirstName LIKE 'SA%'

--02.
SELECT FirstName, LastName FROM Employees 
WHERE LastName LIKE '%ei%'

--03.
SELECT FirstName FROM Employees
WHERE (HireDate>=1995 OR HireDate<=2005) AND DepartmentID IN (3,10)

--04.
SELECT FirstName, LastName FROM Employees
WHERE JobTitle NOT LIKE '%engineer%'

--05.
SELECT Name FROM Towns
WHERE LEN(Name)=5 OR LEN(Name)=6
ORDER BY Name

--06.
SELECT TownID, Name FROM Towns
WHERE Name LIKE 'M%' OR Name LIKE 'K%' OR Name LIKE 'B%' OR Name LIKE'E%'
ORDER BY Name

--07.
SELECT TownID, Name FROM Towns
WHERE Name NOT LIKE 'R%' AND Name NOT LIKE 'B%' AND Name NOT LIKE 'D%'
ORDER BY Name

--08.
CREATE VIEW V_EmployeesHiredAfter2000 AS 
SELECT FirstName, LastName FROM Employees
WHERE HireDate >'2001'

--09.
SELECT FirstName, LastName FROM Employees
WHERE LEN(LastName)=5

--10.
USE Geography -- DO NOT submit in the judge system Use Geography statement in judge or you will get compile time error.
SELECT CountryName, IsoCode AS [ISO Code] FROM Countries
WHERE CountryName LIKE '%A%A%A%'
ORDER BY [ISO Code]

--11.
SELECT PeakName, 
RiverName, 
LOWER(PeakName + RIGHT(RiverName, LEN(RiverName) -1 )) AS 'Mix' FROM Rivers, Peaks
WHERE RIGHT(PeakName,1) = LEFT(RiverName,1)
ORDER BY Mix

--12.
USE Diablo -- DO NOT submit in the judge system Use Diablo statement in judge or you will get compile time error.
SELECT TOP(50) Name,FORMAT(Start,'yyyy-MM-dd')AS Start FROM Games
WHERE YEAR(Start) BETWEEN 2011 AND 2012
ORDER BY Start, Name

--13.
SELECT Username, RIGHT(Email, LEN(Email) - CHARINDEX('@',Email)) AS 'Email Provider' FROM Users
ORDER BY [Email Provider], Username

--14.
SELECT Username, IpAddress FROM Users
WHERE IpAddress LIKE '___.1%.%.___'
ORDER BY Username

--15.
Select G.Name as Game,
Case 
When DATEPART(HOUR,G.Start) Between 0 and 11 Then 'Morning'
When DATEPART(HOUR,G.Start) Between 12 and 17 Then 'Afternoon'
When DATEPART(HOUR,G.Start) Between 18 and 23 Then 'Evening'
END AS [Part of the Day],
Case
When G.Duration <=3 THEN 'Extra Short'
When G.Duration Between 4 AND 6 THEN 'Short'
When G.Duration >6 THEN 'Long'
ELSE 'Extra Long'
END as [Duration]
from Games as G
Order BY G.Name,
[Duration],
[Part of the Day]

--16. -- DO NOT submit in the judge system Use Orders statement in judge or you will get compile time error.
USE Orders
SELECT ProductName, OrderDate,
DATEADD(DAY, 3, OrderDate) AS [Pay Due],
DATEADD(MONTH, 1, OrderDate) AS [Deliver Due]
FROM Orders
