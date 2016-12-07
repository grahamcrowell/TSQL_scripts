USE DQMF
GO


DECLARE @DatabaseName varchar(100);
SET @DatabaseName = 'DSDW'
--SET @DatabaseName = 'CommunityMart'

DECLARE @SubjectAreaName varchar(100);
SET @SubjectAreaName = 'Dimension Tables DSDW'
--SET @SubjectAreaName = 'Dimension Tables Community Data Mart'

DECLARE @ObjectDisplayName varchar(100);
SET @ObjectDisplayName = 'Community Service Location Dimension'

DECLARE @ObjectSchemaName varchar(100);
SET @ObjectSchemaName = 'Dim'

DECLARE @ObjectPhysicalName varchar(100);
SET @ObjectPhysicalName = 'CommunityServiceLocation'

DECLARE @ObjectPKField varchar(100);
SET @ObjectPKField = 'CommunityServiceLocationID'

DECLARE @ObjectType varchar(100);
SET @ObjectType = 'Table'

DECLARE @ObjectPurpose varchar(100);
SET @ObjectPurpose = 'Dimension Source'
--SET @ObjectPurpose = 'Dimension Copy'

DECLARE @ObjectShortDescription varchar(100);
SET @ObjectShortDescription = 'Location where health service occurred.'

DECLARE @IsActive bit;
SET @IsActive = 1;

DECLARE @CreatedBy varchar(100);
SET @CreatedBy = 'VCH\GCrowell'

DECLARE @IsObjectInDB bit;
SET @IsObjectInDB = 1;

DECLARE @ObjectID int;
SET @ObjectID = 53948; --DSDW
--SET @ObjectID = 53949; --CommunityMart

DECLARE @DatabaseId int;
SELECT @DatabaseId = DatabaseId
	FROM DQMF.dbo.MD_Database
	WHERE DatabaseName = @DatabaseName;

DECLARE @SubjectAreaID int;
SELECT @SubjectAreaID = SubjectAreaID
	FROM DQMF.dbo.MD_SubjectArea
	WHERE SubjectAreaName = @SubjectAreaName;

SELECT 
	@DatabaseId AS DatabaseId
	,@DatabaseName AS DatabaseName
	,@SubjectAreaID AS SubjectAreaID
	,@SubjectAreaName AS SubjectAreaName
	,@ObjectPhysicalName AS ObjectPysicalName

--------SELECT @ObjectID=MAX(ObjectID)+1 FROM MD_Object;
------SELECT @ObjectID AS [new ObjectID]





--INSERT INTO MD_Object
--	(DatabaseId,SubjectAreaID,ObjectID,ObjectDisplayName,ObjectSchemaName,ObjectPhysicalName,ObjectPKField,ObjectType,ObjectPurpose,ObjectShortDescription,IsActive,CreatedBy,UpdatedBy,IsObjectInDB)
--VALUES 
--	(@DatabaseId,@SubjectAreaID,@ObjectID,@ObjectDisplayName,@ObjectSchemaName,@ObjectPhysicalName,@ObjectPKField,@ObjectType,@ObjectPurpose,@ObjectShortDescription,@IsActive,@CreatedBy,@CreatedBy,@IsObjectInDB)
