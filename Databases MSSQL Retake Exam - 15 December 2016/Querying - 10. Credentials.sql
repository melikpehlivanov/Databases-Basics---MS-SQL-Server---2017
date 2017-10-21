SELECT u.Nickname, c.Email, c.Password FROM Users AS u
JOIN Credentials AS c ON c.Id = u.CredentialId
WHERE Email LIKE '%co.uk'
ORDER BY Email