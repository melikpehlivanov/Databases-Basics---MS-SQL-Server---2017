SELECT Content, SentOn FROM Messages
WHERE SentOn > '05-12-2014'
AND Content LIKE '%just%'
ORDER BY Id DESC