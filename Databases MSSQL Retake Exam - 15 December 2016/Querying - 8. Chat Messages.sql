SELECT c.Id, Title, m.Id FROM Chats AS c
FULL JOIN Messages AS m ON m.ChatId = c.Id
WHERE m.SentOn < '2012-03-26'
AND Title LIKE '%x'
ORDER BY c.Id, m.Id