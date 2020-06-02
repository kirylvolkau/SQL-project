USE StreamingCompany
GO
SELECT v.ViewerId, v.UserName, c.ChannelId FROM Viewers v, Channels c
WHERE NOT EXISTS (
    SELECT 1 FROM ViewingRequests vr
    WHERE vr.ChannelId = c.ChannelId AND v.ViewerId = vr.ViewerId
)
ORDER BY v.ViewerId, c.ChannelId