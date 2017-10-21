SELECT
TOP 1 WITH TIES c.Title, m.Content FROM Chats AS c
LEFT JOIN Messages AS m ON m.ChatId = c.Id
ORDER BY StartDate DESC, SentOn ASC