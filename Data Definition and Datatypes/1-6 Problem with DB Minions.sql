--1-6 problem
CREATE DATABASE Minions

CREATE TABLE Minions
(
	Id INT NOT NULL PRIMARY KEY,
	Name nvarchar(50),
	Age int
)

CREATE TABLE Towns
(
	Id INT NOT NULL PRIMARY KEY,
	Name nvarchar(50)
)

ALTER TABLE Minions
ADD CONSTRAINT FK_Town FOREIGN KEY (TownId) -- makes TownId foreign key and references to Id column of towns table
REFERENCES Towns (Id)

INSERT INTO Towns (Id, Name)
VALUES (1, 'Sofia')

INSERT INTO Towns (Id, Name)
VALUES (2, 'Plovdiv')

INSERT INTO Towns (Id, Name)
VALUES (3, 'Varna')

INSERT INTO Minions (Id,Name, Age, TownID)
VALUES (1, 'Kevin', 22, 1)

INSERT INTO Minions (Id,Name, Age, TownID)
VALUES (2, 'Bob', 15, 3)

INSERT INTO Minions (Id,Name, Age, TownID)
VALUES (3, 'Steward', NULL , 2)

TRUNCATE TABLE Minions
DROP TABLE Minions
DROP TABLE Towns
