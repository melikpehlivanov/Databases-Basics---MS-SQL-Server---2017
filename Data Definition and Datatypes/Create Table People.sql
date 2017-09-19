CREATE TABLE People
(
	Id int IDENTITY(1,1) UNIQUE,
	Name nvarchar(225) NOT NULL,
	Picture varbinary CHECK(DATALENGTH(Picture)<900*1024),
	Height decimal(10, 2),
	Weight decimal(10,2),
	Gender varchar(1) NOT NULL Check(Gender ='m' OR Gender ='f'),
	Birthdate int NOT NULL,
	Biography nvarchar(255)
)

INSERT INTO People (Name, Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES ('Peter',NULL, 2,522, 'f', 22, 'co-worker')

INSERT INTO People (Name, Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES ('Vankata',NULL, NULL,3.6, 'm', 32, 'captain')

INSERT INTO People (Name, Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES ('Muckata',NULL, NULL,7.8, 'f', 14, 'Driver')

INSERT INTO People (Name, Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES ('Trupkata',NULL, NULL,20.22, 'm', 15, 'Pilot')

INSERT INTO People (Name, Picture, Height, Weight, Gender, Birthdate, Biography)
VALUES ('Goshkata',NULL, NULL,31.01, 'f', 1, 'Worker')
