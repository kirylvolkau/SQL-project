DROP DATABASE IF EXISTS WarehouseModel_kvolkau
GO
CREATE DATABASE WarehouseModel_kvolkau
GO
USE WarehouseModel_kvolkau
GO
-- Servers dimension table
CREATE TABLE Servers(
    ServerId INT PRIMARY KEY NOT NULL,
    ServerName VARCHAR(50) NOT NULL,
    CreationDate DATETIME NOT NULL,
    DestructionDate DATETIME,--nullable
    Capacity INT NOT NULL
)
-- Channels dimension table
CREATE TABLE Channels (
    ChannelId INT PRIMARY KEY NOT NULL,
    ChannelName VARCHAR(50) NOT NULL,
    Category VARCHAR(50), --nullable
    ExpirationDate DATETIME NOT NULL
)
-- Viewers dimension table
CREATE TABLE Viewers (
    ViewerId INT PRIMARY KEY NOT NULL,
    UserName VARCHAR(30) NOT NULL,
    Country VARCHAR(60) NOT NULL,
    Email VARCHAR(50) NOT NULL,
    CONSTRAINT UC_Viewer UNIQUE (UserName, Country, Email)
)
-- Viewing Request Table of Facts
CREATE TABLE ViewingRequest (
    RequestId INT PRIMARY KEY NOT NULL,
    RequestTime DATETIME NOT NULL,
    DurationInSeconds INT, -- nullable,
    [Status] VARCHAR(30) NOT NULL,
    StatusTime DATETIME NOT NULL,
    ChannelId INT NOT NULL FOREIGN KEY REFERENCES Channels(ChannelId),
    ViewerId INT NOT NULL FOREIGN KEY REFERENCES Viewers(ViewerId),
    ServerId INT FOREIGN KEY REFERENCES Servers(ServerId) -- nullable
)