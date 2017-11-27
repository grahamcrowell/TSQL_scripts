USE DQMF
GO

DECLARE @exclude_me varchar(500) = '%ReferralPriority%'

DECLARE @pSourceDatabaseName VARCHAR(50) = 'DSDW', 
	@pDataMartDatabaseName VARCHAR(50) = 'CommunityMart',
	@pDataMartSubjectAreaName VARCHAR(50) = 'Dimension Tables Community Data Mart', 
	@pObjectPurpose VARCHAR(100) = 'Dimension Copy',
	@pCopyData BIT = 1,
	@Debug TINYINT = 10

SELECT  
	ObjectPhysicalName
	,ObjectSchemaName
	,ObjectPKField
	,db.DatabaseName AS Source
	,@pDataMartDatabaseName AS Dest
	,SubjectAreaName
	,ObjectPurpose
FROM DQMF.dbo.MD_Object AS obj
JOIN DQMF.dbo.MD_Database AS db
ON obj.DatabaseId = db.DatabaseId
JOIN DQMF.dbo.MD_SubjectArea AS sub
ON obj.SubjectAreaID = sub.SubjectAreaID
WHERE 1=1
AND db.DatabaseName = @pDataMartDatabaseName
AND SubjectAreaName = @pDataMartSubjectAreaName
AND ObjectPurpose = @pObjectPurpose
AND obj.IsActive = 1
AND db.IsActive = 1
AND sub.IsActive = 1
AND obj.ObjectPhysicalName NOT LIKE @exclude_me

EXECUTE [dbo].[CopyDataMartOjects] 
   @pSourceDatabaseName
  ,@pDataMartDatabaseName
  ,@pDataMartSubjectAreaName
  ,@pObjectPurpose
  ,@pCopyData
  ,@Debug
GO

SELECT *
FROM CommunityMart.Dim.ReferralPriority