SELECT Nickname, c.Title, l.Latitude, l.Longitude FROM Users AS u
JOIN Locations AS l ON l.Id = u.LocationId
JOIN UsersChats AS uc ON uc.UserId = u.Id
JOIN Chats AS c ON c.Id = uc.ChatId
WHERE (l.Latitude BETWEEN 41.139999 AND 44.12999) AND
(l.Longitude BETWEEN 22.20999 AND 28.35999)
ORDER BY c.Title
