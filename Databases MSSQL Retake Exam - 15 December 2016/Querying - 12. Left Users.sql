SELECT m.Id, m.ChatId, m.UserId FROM Messages AS m
WHERE m.ChatId = 17
AND m.UserId NOT IN(SELECT UserId FROM UsersChats WHERE ChatId = m.ChatId) OR m.UserId IS NULL 
ORDER BY m.Id DESC
