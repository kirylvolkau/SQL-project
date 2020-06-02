USE StreamingCompany
GO
UPDATE Servers 
SET CurrentUsersAmt = tmp.Amt
FROM (SELECT s.ServerId as [SID], COUNT(DISTINCT vs.ViewerId) as Amt FROM Servers s
JOIN ViewingRequests vs ON vs.ServerId = s.ServerId
WHERE vs.StatusId = 100
GROUP BY s.ServerId) tmp 
WHERE ServerId = tmp.[SID];