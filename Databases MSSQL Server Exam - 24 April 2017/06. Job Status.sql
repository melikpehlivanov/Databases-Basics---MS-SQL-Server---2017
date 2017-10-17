SELECT Status, IssueDate FROM Jobs
WHERE FinishDate IS NULL
ORDER BY IssueDate, JobId
