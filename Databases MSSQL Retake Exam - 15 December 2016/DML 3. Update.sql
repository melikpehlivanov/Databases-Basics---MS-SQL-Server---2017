UPDATE Chats
SET StartDate = SentOn FROM Messages JOIN Chats ON Messages.ChatId = Chats.Id WHERE StartDate > SentOn