CREATE TRIGGER InsertTrigger
ON 
ViewingRequests
AFTER INSERT
AS 
BEGIN
EXEC ServeRequest
END
