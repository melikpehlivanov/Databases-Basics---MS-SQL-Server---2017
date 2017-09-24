CREATE TABLE Users
(
	Id int IDENTITY(1,1) UNIQUE,
	Username nvarchar(30) UNIQUE NOT NULL,
	Password nvarchar(26) NOT NULL,
	ProfilePicture varbinary CHECK(DATALENGTH(ProfilePicture)<900*1024),
	LastLoginTime date,
	IsDeleted nvarchar(5) NOT NULL CHECK(IsDeleted='true' or isDeleted='false') 
)

INSERT INTO Users (Username, Password, ProfilePicture,LastLoginTime, IsDeleted)
VALUES('Melik', 'Melik123456789', 36, Null, 'true')

INSERT INTO Users (Username, Password, ProfilePicture, LastLoginTime, IsDeleted)
VALUES('Gosho', 'Gosho1234', 450,Null,'false')

INSERT INTO Users (Username, Password, ProfilePicture, LastLoginTime, IsDeleted)
VALUES('Pesho', 'Pesho123', 21,Null,'true')

INSERT INTO Users (Username, Password, ProfilePicture, LastLoginTime, IsDeleted)
VALUES('Vankata', 'Vankata123321',500,Null,'false')

INSERT INTO Users (Username, Password, ProfilePicture, LastLoginTime, IsDeleted)
VALUES('Baba', 'Baba54212', 352,Null,'false')
