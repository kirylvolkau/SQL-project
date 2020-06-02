USE StreamingCompany
GO
WITH RequestDurations(RequestId, Duration) AS (
    SELECT vr.RequestId, tmp.DurationInSecs FROM ViewingRequests vr
    JOIN (
        SELECT rsh.RequestId, ABS(DATEDIFF(SECOND, rsh.RequestTime, rsh3.RequestTime)) as DurationInSecs FROM RequestStatusHistory rsh 
        JOIN RequestStatusHistory rsh3 ON rsh3.RequestId = rsh.RequestId AND rsh3.StatusId = 200
        WHERE rsh.StatusId = 100
    )   tmp ON tmp.RequestId = vr.RequestId
)
SELECT TOP(3) c.ChannelId, c.ChannelName, COUNT(rd.RequestId) AS CountOfShots FROM Channels c
JOIN ViewingRequests vr ON vr.ChannelId = c.ChannelId 
JOIN RequestDurations rd ON rd.RequestId = vr.RequestId
WHERE rd.Duration < 15
GROUP BY c.ChannelId, c.ChannelName
