USE gcDev
GO

IF OBJECT_ID('dbo.EtlRunTimeLog','U') IS NOT NULL
DROP TABLE EtlRunTimeLog;
GO

CREATE TABLE EtlRunTimeLog (
	StartDate date
	,PackageName varchar(100)
	,TaskName varchar(100)
	,VersionBuild int
	,Note varchar(1000)
);
GO

IF OBJECT_ID('dbo.LogIt','P') IS NOT NULL
DROP PROC dbo.LogIt;
GO
CREATE PROC dbo.LogIt 
	@PackageName varchar(100)
	,@TaskName varchar(100)
	,@VersionBuild int
	,@Note varchar(1000)
AS
BEGIN
	INSERT INTO EtlRunTimeLog (StartDate, PackageName, TaskName, Note) VALUES (GETDATE(), @PackageName, @TaskName, @VersionBuild, @Note);
END
GO
EXEC dbo.LogIt @PackageName=?, @TaskName=?, @VersionBuild=?, @Note=?;