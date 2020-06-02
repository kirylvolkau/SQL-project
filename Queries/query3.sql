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
SELECT TOP(10) c.CountryId, c.CoutntryName, 
SUM(rd.Duration)/COUNT(rd.RequestId) AS Ratio
FROM Countries c
RIGHT JOIN Viewers v ON v.CountryId = c.CountryId
JOIN ViewingRequests vr ON vr.ViewerId = v.ViewerId
JOIN RequestDurations rd ON rd.RequestId = vr.RequestId
GROUP BY c.CountryId, c.CoutntryName
ORDER BY Ratio DESC


