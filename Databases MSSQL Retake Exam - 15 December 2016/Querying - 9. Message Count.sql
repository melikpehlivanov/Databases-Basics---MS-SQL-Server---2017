SELECT TOP 5  c.Id, COUNT(m.Id) AS [TotalMessages] FROM Chats AS c
FULL JOIN Messages AS m ON m.ChatId = c.Id
WHERE m.Id < 90
GROUP BY c.Id
ORDER BY TotalMessages DESC, c.Id