USE master
GO
DROP DATABASE IF EXISTS StreamingCompany
GO
CREATE DATABASE StreamingCompany
GO
USE StreamingCompany
GO
-- Channel categories table.
CREATE TABLE ChannelCategories(
    CategorieId INT IDENTITY(1,1) NOT NULL,
    CategoryName VARCHAR(50) NOT NULL,
    CONSTRAINT PK_ChannelCategorie PRIMARY KEY(CategorieId)
)
-- Channels table
CREATE TABLE Channels(
    ChannelId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    ChannelName VARCHAR(50) NOT NULL,
    ExpirationDate DATETIME NOT NULL,
    CategorieId INT FOREIGN KEY REFERENCES ChannelCategories(CategorieId)
)
-- Servers table
CREATE TABLE [Servers] (
    ServerId INT NOT NULL PRIMARY KEY IDENTITY(1,1),
    ServerName VARCHAR(50) NOT NULL,
    CreationDate DATETIME NOT NULL,
    ExpiratioCnDate DATETIME,
    Capacity INT NOT NULL,
    CurrentUsersAmt INT NOT NULL DEFAULT 0,
	CHECK (CurrentUsersAmt <= Capacity)
)
-- Junction table ChannelServer for many-to-many relationship 
CREATE TABLE ChannelServer(
    ChannelId INT NOT NULL FOREIGN KEY REFERENCES Channels(ChannelId),
    ServerId INT NOT NULL FOREIGN KEY REFERENCES Servers(ServerId),
    CONSTRAINT PK_ChannelServer PRIMARY KEY (ChannelId, ServerId)
)
-- Countries table
CREATE TABLE Countries(
    CountryId INT NOT NULL PRIMARY KEY,
    CoutntryName VARCHAR(60) NOT NULL, 
)
-- ViewersId
CREATE TABLE Viewers(
    ViewerId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    UserName VARCHAR(30) NOT NULL,
    CountryId INT FOREIGN KEY REFERENCES Countries(CountryId),
    Email VARCHAR(254) NOT NULL,
    CONSTRAINT UC_Viewer UNIQUE (UserName, CountryId, Email)
)
-- Junction table ViewerChannel for many-to-many relationship   
CREATE TABLE ViewerChannel(
    ViewerId INT NOT NULL FOREIGN KEY REFERENCES Viewers(ViewerId),
    ChannelId INT NOT NULL FOREIGN KEY REFERENCES Channels(ChannelId),
    CONSTRAINT PK_ViewerChannel PRIMARY KEY (ViewerId, ChannelId)
)
-- Request statuses
CREATE TABLE RequestStatuses(
    StatusId INT NOT NULL PRIMARY KEY,
    StatusText VARCHAR(MAX) NOT NULL
)
-- ViewingRequests
CREATE TABLE ViewingRequests(
    RequestId INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    RequestTime DATETIME NOT NULL DEFAULT GETDATE(),
    ChannelId INT NOT NULL FOREIGN KEY REFERENCES Channels(ChannelId),
    StatusId INT NOT NULL FOREIGN KEY REFERENCES RequestStatuses(StatusId) DEFAULT 300,
	ViewerId INT NOT NULL FOREIGN KEY REFERENCES Viewers(ViewerId),
    ServerId INT FOREIGN KEY REFERENCES Servers(ServerId),
    StatusTime DATETIME NOT NULL DEFAULT GETDATE()
);
-- history table for requests
CREATE TABLE RequestStatusHistory (
    RequestId INT NOT NULL FOREIGN KEY REFERENCES ViewingRequests(RequestId),
    StatusId INT NOT NULL FOREIGN KEY REFERENCES RequestStatuses(StatusId),
    RequestTime DATETIME NOT NULL,
    CONSTRAINT PK_RequestStatusEntry PRIMARY KEY(RequestId, StatusId)
);