SELECT Title, IsActive FROM Chats
WHERE (IsActive = 0
AND (LEN(Title) < 5)) OR (Title LIKE '__tl%')
ORDER BY Title DESC 