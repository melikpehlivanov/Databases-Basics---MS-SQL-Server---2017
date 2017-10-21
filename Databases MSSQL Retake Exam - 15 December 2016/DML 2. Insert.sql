INSERT INTO Messages(Content, SentOn, ChatId, UserId)
SELECT
CONCAT(Age, '-', Gender, '-', l.Latitude, '-', l.Longitude),
GETDATE(),
CASE
	WHEN Gender = 'F' THEN CEILING(SQRT(Age * 2))
	WHEN Gender = 'M' THEN CEILING(POWER(AGE / 18, 3))
END,
u.Id
FROM Users AS u
JOIN Locations AS l ON l.Id = u.LocationId
WHERE u.Id BETWEEN 10 AND 20
