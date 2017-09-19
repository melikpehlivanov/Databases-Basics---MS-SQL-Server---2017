INSERT INTO Employees(FirstName, MiddleName, LastName,JobTitle,DepartmentId,HireDate,Salary,AddressId)
VALUES('Ivan','Ivanov','Ivanov', '.NET DEVELOPER', 'Software Development', '01/02/2013', 3500, NULL)
INSERT INTO Employees(FirstName, MiddleName, LastName,JobTitle,DepartmentId,HireDate,Salary,AddressId)
VALUES('Petar','Petrov','Petrov', 'Senior Engineer', 'Engineering', '02/03/2004', 4000, NULL)
INSERT INTO Employees(FirstName, MiddleName, LastName,JobTitle,DepartmentId,HireDate,Salary,AddressId)
VALUES('Maria','Petrova','Ivanova', 'Intern', 'Quality Assurance', '28/08/2016', 525.25, NULL)
INSERT INTO Employees(FirstName, MiddleName, LastName,JobTitle,DepartmentId,HireDate,Salary,AddressId)
VALUES('Georgi','Terziev','Ivanov', 'CEO', 'Sales', '09/12/2007', 3000, NULL)
INSERT INTO Employees(FirstName, MiddleName, LastName,JobTitle,DepartmentId,HireDate,Salary,AddressId)
VALUES('Peter','Pan','Pan', 'Intern', 'Marketing', '28/08/2016', 599.88, NULL)

select * from Employees where HireDate between '2000/01/01' and '2099/12/31'

--19. Basic Select All fields
SELECT * FROM Towns
SELECT * FROM Departments
SELECT * FROM Employees

--20. Basic Select All Fields and Order Them
SELECT * FROM Towns
ORDER BY Name
SELECT * FROM Departments
ORDER BY Name
SELECT * FROM Employees
ORDER BY Salary DESC

--21. Basic Select Some Fields
SELECT Name FROM Towns ORDER BY Name
SELECT Name FROM Departments ORDER BY Name
SELECT FirstName, LastName, JobTitle, Salary FROM Employees ORDER BY Salary DESC

--22. Increase Employees Salary
UPDATE Employees
SET Salary+=Salary*10/100
SELECT Salary FROM Employees

--23. Decrease Tax Rate Hotel Database
UPDATE Payments
SET TaxRate-=TaxRate*3/100
SELECT TaxRate FROM Payments

--24. Delete All Records From Hotel Database table Occupancies
TRUNCATE TABLE Occupancies
