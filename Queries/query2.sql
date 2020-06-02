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
SELECT DISTINCT c.ChannelId, c.ChannelName, 
AVG(rd.Duration) AS ChannelUserDuration, 
AVG(T1.Duration) AS ChannelViewerDuration  FROM Channels c
JOIN ViewingRequests vr ON c.ChannelId = vr.ChannelId
RIGHT JOIN RequestDurations rd ON rd.RequestId = vr.RequestId
JOIN (
    SELECT rd1.RequestId, rd1.Duration FROM RequestDurations rd1
    JOIN ViewingRequests vr1 ON rd1.RequestId = vr1.RequestId
    JOIN Viewers v1 ON v1.ViewerId = v1.ViewerId
) AS T1 ON vr.RequestId = T1.RequestId
GROUP BY c.ChannelId, c.ChannelName
HAVING AVG(T1.Duration) > AVG(rd.Duration) + AVG(rd.Duration)*0.45
