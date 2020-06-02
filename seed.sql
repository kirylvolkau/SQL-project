USE StreamingCompany
GO
INSERT INTO RequestStatuses (StatusId, StatusText)
VALUES 
(100, 'served'),
(200, 'closed'),
(300, 'open'),
(400, 'rejected'),
(418, 'I am a teapot!');

INSERT INTO Countries (CountryId, CoutntryName)
VALUES
(1, 'United States of America'),
(2, 'Poland'),
(3, 'Belarus'),
(4, 'United Kingdom'),
(5, 'Neverland');

INSERT INTO [dbo].[Servers] (ServerName, CreationDate, Capacity)
VALUES
('1st Server', '20120618 10:34:09 AM', 4),
('2nd Server', '20120618 10:33:09 AM', 2),
('3rd Server', '20200101 10:00:00 PM', 10),
('4th Server', '20161201 00:00:00 AM', 3),
('5th Server', '20010527 11:33:00 AM', 19);

INSERT INTO ChannelCategories (CategoryName)
VALUES 
('Sport'),
('Music'),
('Chess'),
('Education'),
('Adult content');

INSERT INTO Channels (ChannelName, CategorieId, ExpirationDate)
VALUES
('BBC', NULL, '20200616'),
('Chess.com', 3, '20200617'),
('TikTok', 2, '20220101'),
('Okno',4, '20200415'),
('SomeHub', 5, '20300101'),
('Festival', 3, '20210116'),
('EuroSport', 1, '20200909 10 AM'),
('ForgottenOne', NULL, '20200909' );

INSERT INTO Viewers (UserName, CountryId, Email)
VALUES
('erlobo', 1, 'k.volkau@student.mini.pw.edu.pl'),
('romans', 2,'romaroma@gmail.com'),
('tativo', 3, 'tativophotos@gmail.com'),
('avolkau',4, 'avlist@minsk.by'),
('viewer', 5, 'viewer@viewer.ru'),
('viewer1', 1, 'v1@v1.com'),
('asterix', 3, 'ghghgh@mail.ru');

INSERT INTO ViewerChannel (ChannelId, ViewerId)
VALUES
(1,1),
(1,2),
(2,2),
(3,3),
(3,2),
(5,4),
(1,3),
(4,5);

INSERT INTO ChannelServer 
VALUES
(1,1),
(1,2),
(2,1),
(2,3),
(3,4),
(4,5),
(6,1),
(7,1);

INSERT INTO ViewingRequests (ViewerId, ChannelId, RequestTime, StatusId, StatusTime, ServerId)
VALUES
(1,1, GETDATE(),100, GETDATE(),1),
(1,2, GETDATE(), 100, GETDATE(), 1),
(2,3, GETDATE(), 100, GETDATE(), 1),
(2,4, GETDATE(), 100, GETDATE(), 2),
(3,5, GETDATE(),200, GETDATE(), 3),
(1,3, GETDATE(), 200, GETDATE(), NULL),
(1,4, GETDATE(), 300, GETDATE(), NULL),
(4,5, GETDATE(), 300, GETDATE(), NULL),
(5,5, GETDATE(), 300, GETDATE(), NULL),
(3,1, GETDATE(), 400, GETDATE(),NULL),
(7,2, GETDATE(), 100, GETDATE(),NULL),
(1,8, GETDATE(), 300, GETDATE(), NULL);

INSERT INTO RequestStatusHistory
VALUES
(1, 100, GETDATE()),
(1, 300, DATEADD(MINUTE,-1,GETDATE())),
(2, 100, GETDATE()),
(2, 300, DATEADD(MINUTE,-1,GETDATE())),
(3, 100, GETDATE()),
(5, 300, DATEADD(HOUR,-3, GETDATE())),
(5, 100, DATEADD(MINUTE,-179, GETDATE())),
(5,200, GETDATE());




