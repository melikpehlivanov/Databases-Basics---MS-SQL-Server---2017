--01. Number of Users for Email Provider
SELECT 
  RIGHT(Email, LEN(Email) - CHARINDEX('@', Email)) AS [Email Provider], 
  COUNT(*) AS [Number of Users]
FROM Users
GROUP BY RIGHT(Email, LEN(Email) - CHARINDEX('@', Email))
ORDER BY [Number of Users] DESC, [Email Provider]

--02. All Users in Games
SELECT g.Name AS Game, gt.Name AS [Game Type],
  u.Username, ug.Level, ug.Cash, c.Name AS Character
FROM UsersGames AS ug
  JOIN Games AS g ON ug.GameId = g.Id
  JOIN GameTypes AS gt ON g.GameTypeId = gt.Id
  JOIN Users AS u ON ug.UserId = u.Id
  JOIN Characters AS c ON ug.CharacterId = c.Id
ORDER BY ug.Level DESC, u.Username, Game

--03. Users in Games with Their Items
SELECT u.Username, g.Name AS Game,
  COUNT(ugi.ItemId) AS [Items Count],
  SUM(i.Price) AS [Items Price]
FROM UsersGames AS ug
  JOIN Users AS u ON ug.UserId = u.Id
  JOIN Games AS g ON ug.GameId = g.Id
  JOIN UserGameItems AS ugi ON ugi.UserGameId = ug.Id -- NB! ug.Id <> g.Id
  JOIN Items AS i ON ugi.ItemId = i.Id
GROUP BY u.Username, g.Name
HAVING COUNT(ugi.ItemId) >= 10
ORDER BY
  [Items Count] DESC, [Items Price] DESC, u.Username

--04. * User in Games with Their Statistics
SELECT 
  u.Username, g.Name AS Game, MAX(c.Name) AS Character, 
  MAX(cs.Strength) + MAX(gts.Strength) + SUM(gis.Strength) AS Strength, 
  MAX(cs.Defence) + MAX(gts.Defence) + SUM(gis.Defence) AS Defence, 
  MAX(cs.Speed) + MAX(gts.Speed) + SUM(gis.Speed) AS Speed, 
  MAX(cs.Mind) + MAX(gts.Mind) + SUM(gis.Mind) AS Mind, 
  MAX(cs.Luck) + MAX(gts.Luck) + SUM(gis.Luck) AS Luck
FROM UsersGames AS ug
JOIN Users AS u ON ug.UserId = u.Id
JOIN Games AS g ON ug.GameId = g.Id
JOIN Characters AS c ON ug.CharacterId = c.Id
JOIN [Statistics] AS cs ON c.StatisticId = cs.Id
JOIN GameTypes AS gt ON gt.Id = g.GameTypeId
JOIN [Statistics] AS gts ON gts.Id = gt.BonusStatsId
JOIN UserGameItems AS ugi ON ugi.UserGameId = ug.Id
JOIN Items AS i ON i.Id = ugi.ItemId
JOIN [Statistics] AS gis ON gis.Id = i.StatisticId
GROUP BY u.Username, g.Name
ORDER BY Strength DESC, Defence DESC, Speed DESC, Mind DESC, Luck DESC

--05. All Items with Greater than Average Statistics
WITH CTE_AboveAverageStats (Id) AS (  
  SELECT Id FROM [Statistics]
  WHERE Mind > (SELECT AVG(Mind  * 1.0) FROM [Statistics]) AND
        Luck > (SELECT AVG(Luck  * 1.0) FROM [Statistics]) AND
       Speed > (SELECT AVG(Speed * 1.0) FROM [Statistics])
)
SELECT 
  i.Name, i.Price, i.MinLevel, 
  s.Strength, s.Defence, s.Speed, s.Luck, s.Mind
FROM CTE_AboveAverageStats AS av
  JOIN [Statistics] AS s ON av.Id = s.Id
  JOIN Items AS i ON i.StatisticId = s.Id
ORDER BY i.Name

--06. Display All Items about Forbidden Game Type
SELECT i.Name AS Item, i.Price, i.MinLevel, gt.Name AS [Forbidden Game Type]
FROM Items AS i -- all items
  LEFT JOIN GameTypeForbiddenItems AS fi ON fi.ItemId = i.Id
  LEFT JOIN GameTypes AS gt ON fi.GameTypeId = gt.Id
ORDER BY [Forbidden Game Type] DESC, Item

--07. Buy Items for User in Game
DECLARE @gameName nvarchar(50) = 'Edinburgh';
DECLARE @username nvarchar(50) = 'Alex';
DECLARE @userGameId int = (
  SELECT ug.Id 
  FROM UsersGames AS ug
  JOIN Users AS u ON ug.UserId = u.Id
  JOIN Games AS g ON ug.GameId = g.Id
  WHERE u.Username = @username AND g.Name = @gameName

);

DECLARE @availableCash money = (SELECT Cash FROM UsersGames WHERE Id = @userGameId);
DECLARE @purchasePrice money = (
  SELECT SUM(Price) FROM Items WHERE Name IN 
  ('Blackguard', 'Bottomless Potion of Amplification', 'Eye of Etlich (Diablo III)',
  'Gem of Efficacious Toxin', 'Golden Gorget of Leoric', 'Hellfire Amulet')

); 

-- validating min game level not required
IF (@availableCash >= @purchasePrice) 
BEGIN 
  BEGIN TRANSACTION  

  UPDATE UsersGames SET Cash -= @purchasePrice WHERE Id = @userGameId; 

  IF(@@ROWCOUNT <> 1) 
  BEGIN
    ROLLBACK; RAISERROR('Could not make payment', 16, 1); RETURN;
  END

  INSERT INTO UserGameItems (ItemId, UserGameId) 
  (SELECT Id, @userGameId FROM Items WHERE Name IN 
    ('Blackguard', 'Bottomless Potion of Amplification', 'Eye of Etlich (Diablo III)',
    'Gem of Efficacious Toxin', 'Golden Gorget of Leoric', 'Hellfire Amulet')) 

  IF((SELECT COUNT(*) FROM Items WHERE Name IN 
    ('Blackguard', 'Bottomless Potion of Amplification', 'Eye of Etlich (Diablo III)', 
	'Gem of Efficacious Toxin', 'Golden Gorget of Leoric', 'Hellfire Amulet')) <> @@ROWCOUNT)
  BEGIN
    ROLLBACK; RAISERROR('Could not buy items', 16, 1); RETURN;
  END	

  COMMIT;

END

-- select users in game with items
SELECT u.Username, g.Name, ug.Cash, i.Name AS [Item Name]
FROM UsersGames AS ug
JOIN Games AS g ON ug.GameId = g.Id
JOIN Users AS u ON ug.UserId = u.Id
JOIN UserGameItems AS ugi ON ug.Id = ugi.UserGameId
JOIN Items AS i ON i.Id = ugi.ItemId
WHERE g.Name = @gameName

--08. Peaks and Mountains
SELECT p.PeakName, m.MountainRange AS Mountain, p.Elevation
FROM Peaks AS p
JOIN Mountains AS m ON p.MountainId = m.Id
ORDER BY p.Elevation DESC, p.PeakName

--09. Peaks with Mountain, Country and Continent
SELECT p.PeakName, m.MountainRange AS Mountain, c.CountryName, cont.ContinentName
FROM Peaks AS p
  JOIN Mountains AS m ON p.MountainId = m.Id
  JOIN MountainsCountries AS mc ON m.Id = mc.MountainId
  JOIN Countries AS c ON mc.CountryCode = c.CountryCode
  JOIN Continents AS cont ON c.ContinentCode = cont.ContinentCode
ORDER BY p.PeakName, c.CountryName

--10. Rivers by Country
SELECT c.CountryName, cont.ContinentName, 
  COUNT(r.Id) AS RiverCount, 
  ISNULL(SUM(r.Length), 0) AS TotalLength
FROM Countries AS c
  LEFT JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
  LEFT JOIN Rivers AS r ON cr.RiverId = r.Id
  LEFT JOIN Continents AS cont on c.ContinentCode = cont.ContinentCode
GROUP BY c.CountryName, cont.ContinentName
ORDER BY RiverCount DESC, TotalLength DESC, c.CountryName

--11. Count of Countries by Currency
SELECT ccy.CurrencyCode, ccy.Description AS Currency, 
  COUNT(c.CountryCode) AS NumberOfCountries
FROM Currencies AS ccy
LEFT JOIN Countries AS c ON c.CurrencyCode = ccy.CurrencyCode
GROUP BY ccy.CurrencyCode, ccy.Description
ORDER BY NumberOfCountries DESC, Currency

--12. Population and Area by Continent
SELECT cont.ContinentName, 
  SUM(c.AreaInSqKm) AS CountriesArea, 
  SUM(CAST(c.Population AS float)) AS CountriesPopulation
FROM Continents AS cont
LEFT JOIN Countries AS c ON cont.ContinentCode = c.ContinentCode
GROUP BY cont.ContinentName
ORDER BY CountriesPopulation DESC

--13. Monasteries by Country
CREATE TABLE Monasteries(
  Id int NOT NULL IDENTITY, 
  Name nvarchar(200) NOT NULL, 
  CountryCode char(2) NOT NULL,
  CONSTRAINT PK_Monasteries PRIMARY KEY (Id),
  CONSTRAINT FK_Monasteries_Countries FOREIGN KEY (CountryCode) REFERENCES Countries(CountryCode)

)

INSERT INTO Monasteries(Name, CountryCode) VALUES
  ('Rila Monastery “St. Ivan of Rila”', 'BG'), 
  ('Bachkovo Monastery “Virgin Mary”', 'BG'),
  ('Troyan Monastery “Holy Mother''s Assumption”', 'BG'),
  ('Kopan Monastery', 'NP'),
  ('Thrangu Tashi Yangtse Monastery', 'NP'),
  ('Shechen Tennyi Dargyeling Monastery', 'NP'),
  ('Benchen Monastery', 'NP'),
  ('Southern Shaolin Monastery', 'CN'),
  ('Dabei Monastery', 'CN'),
  ('Wa Sau Toi', 'CN'),
  ('Lhunshigyia Monastery', 'CN'),
  ('Rakya Monastery', 'CN'),
  ('Monasteries of Meteora', 'GR'),
  ('The Holy Monastery of Stavronikita', 'GR'),
  ('Taung Kalat Monastery', 'MM'),
  ('Pa-Auk Forest Monastery', 'MM'),
  ('Taktsang Palphug Monastery', 'BT'),
  ('Sümela Monastery', 'TR');


WITH CTE_CountriesWithMoreRivers (CountryCode) AS (
  SELECT c.CountryCode
  FROM Countries AS c
  JOIN CountriesRivers AS cr ON c.CountryCode = cr.CountryCode
  GROUP BY c.CountryCode
  HAVING COUNT(cr.RiverId) > 3

)

UPDATE Countries
SET IsDeleted = 1
WHERE CountryCode IN (SELECT * FROM CTE_CountriesWithMoreRivers)

SELECT m.Name AS Monastery, c.CountryName AS Country
FROM Monasteries AS m
JOIN Countries AS c ON c.CountryCode = m.CountryCode
WHERE c.IsDeleted = 0
ORDER BY Monastery

--14. Monasteries by Continents and Countries
UPDATE Countries
SET CountryName = 'Burma'
WHERE CountryName = 'Myanmar'

INSERT INTO Monasteries (Name, CountryCode)
(SELECT 'Hanga Abbey', CountryCode
 FROM Countries AS c 
 WHERE CountryName = 'Tanzania')

 INSERT INTO Monasteries (Name, CountryCode)
(SELECT 'Myin-Tin-Daik', CountryCode
 FROM Countries AS c 
 WHERE CountryName = 'Myanmar')


SELECT cont.ContinentName, c.CountryName, 
  COUNT(m.Name) AS MonasteriesCount
FROM Continents AS cont
  LEFT JOIN Countries AS c ON cont.ContinentCode = c.ContinentCode
  LEFT JOIN Monasteries AS m ON m.CountryCode = c.CountryCode
WHERE c.IsDeleted = 0
GROUP BY cont.ContinentName, c.CountryName
ORDER BY MonasteriesCount DESC, c.CountryName

