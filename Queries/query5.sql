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

SELECT v.ViewerId, v.UserName FROM Viewers v
JOIN ViewingRequests vr ON v.ViewerId = vr.ViewerId
JOIN RequestDurations rd ON rd.RequestId = vr.RequestId

WHERE YEAR(vr.StatusTime) = 2018 AND rd.Duration >= 3600