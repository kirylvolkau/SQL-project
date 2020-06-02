USE StreamingCompany
GO
CREATE PROCEDURE ServeRequest
AS 
DECLARE @id INT
DECLARE @channeldate DATETIME
DECLARE @requestdate DATETIME
DECLARE @serverids TABLE (id INT)
DECLARE @serverid INT
DECLARE @channelid INT
DECLARE request CURSOR LOCAL FOR 
    SELECT RequestId, RequestTime FROM ViewingRequests
    WHERE StatusId = 300
    ORDER BY RequestTime
OPEN request 
FETCH NEXT FROM request INTO @id, @requestdate
WHILE @@FETCH_STATUS=0
BEGIN
    SELECT @channeldate = ExpirationDate, @channelid = c.ChannelId FROM Channels c
    JOIN ViewingRequests ON c.ChannelId = ViewingRequests.ChannelId
    AND ViewingRequests.RequestId = @id

    IF @channeldate < @requestdate
    BEGIN
        UPDATE ViewingRequests SET 
            StatusTime = GETDATE(),
            StatusId = 400
        FROM ViewingRequests vr
        WHERE vr.RequestId = @id

        INSERT INTO RequestStatusHistory (RequestId, StatusId, RequestTime)
        VALUES (@id, 400, GETDATE());
    END
    ELSE
    BEGIN
        INSERT @serverids 
            SELECT s.ServerID FROM Servers s
            JOIN ChannelServer cr ON cr.ServerId = s.ServerId
            WHERE cr.ChannelId = @channelid AND s.Capacity > s.CurrentUsersAmt
            ORDER BY s.CurrentUsersAmt DESC

        DECLARE servercursor CURSOR LOCAL SCROLL FOR SELECT * FROM @serverids
        OPEN ServerCursor 
        FETCH FIRST FROM ServerCursor INTO @serverid
        CLOSE servercursor
        DEALLOCATE servercursor
        DELETE FROM @serverids


        IF @serverid IS NOT NULL
        BEGIN
            UPDATE ViewingRequests SET
                StatusId = 100,
                StatusTime = GETDATE(),
                ServerId = @serverid
            FROM ViewingRequests vr
            WHERE @id = vr.RequestId

            INSERT INTO RequestStatusHistory
            VALUES (@id, 100, GETDATE())

            UPDATE Servers
            SET CurrentUsersAmt = CurrentUsersAmt + 1
            WHERE ServerId = @serverid
        END
        ELSE
        BEGIN
            INSERT INTO Servers (ServerName, Capacity, CreationDate)
            VALUES ('Temp server', 5, GETDATE())

            INSERT INTO ChannelServer (ChannelId,ServerId)
            VALUES (@channelid, IDENT_CURRENT('Servers'))

            UPDATE ViewingRequests SET
                StatusId = 100,
                StatusTime = GETDATE(),
                ServerId = IDENT_CURRENT('Servers')
            FROM ViewingRequests vr
            WHERE @id = vr.RequestId

            UPDATE Servers
            SET CurrentUsersAmt = CurrentUsersAmt + 1
            WHERE ServerId = IDENT_CURRENT('Servers')
        END
    END
    FETCH NEXT FROM request INTO @id, @requestdate
END
CLOSE request
DEALLOCATE request
GO
EXEC ServeRequest