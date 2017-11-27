USE DQMF
GO

DECLARE @ObjectPhysicalName varchar(100);
SET @ObjectPhysicalName = 'CommunityServiceLocation'

SELECT *
FROM MD_Object
WHERE ObjectPhysicalName = @ObjectPhysicalName
GO

DECLARE @pSourceDatabaseName varchar(100);
SET @pSourceDatabaseName = 'DSDW'

DECLARE @pDataMartDatabaseName varchar(100);
SET @pDataMartDatabaseName = 'CommunityMart'

DECLARE @SubjectAreaName varchar(100);
SET @SubjectAreaName = 'Dimension Tables Community Data Mart'

DECLARE @ObjectPurpose varchar(100);
SET @ObjectPurpose = 'Dimension Copy'

EXEC DQMF.[dbo].[CopyDataMartOjects]
	@pSourceDatabaseName = @pSourceDatabaseName
	,@pDataMartDatabaseName = @pDataMartDatabaseName
	,@pDataMartSubjectAreaName = @SubjectAreaName
	,@pObjectPurpose = @ObjectPurpose
	,@pCopyData = 1