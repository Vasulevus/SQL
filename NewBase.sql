CREATE DATABASE TestDB;

USE TestDB;

CREATE TABLE Session(
    [Id_session] BIGINT NOT NULL
    ,[Id_test] INT NOT NULL
    ,[GROUP] INT NOT NULL 
);
CREATE TABLE Events(
    [Id_session] BIGINT NOT NULL
    ,[Id] INT NOT NULL
    ,[Event_type] NVARCHAR(MAX) NOT NULL
)
CREATE TABLE Sales(
    [Id_session] BIGINT not null 
    ,[purchase] float not null
    );

INSERT INTO [TestDB].[dbo].[Session] VALUES
(48374834385734,1,1),
(83923923734374,1,2)

INSERT INTO [TestDB].[dbo].[Sales] VALUES
(48374834385734,10.1),
(48374834385734, 5.1)

INSERT INTO [TestDB].[dbo].[Events] VALUES
(48374834385734,7382382,"click"),
(48374834385734,7382367,"apply")


