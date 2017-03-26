USE DQMF
GO

--EXEC msdb.dbo.sp_start_job N'CCRSXml';

DECLARE @PkgName varchar(100);
DECLARE @StageName varchar(100);
DECLARE @DatabaseName varchar(100);
DECLARE @table_name varchar(100);
DECLARE @IsActive bit;
DECLARE @StageOrder int;
DECLARE @BRId int;
DECLARE @sql varchar(500);
DECLARE @by varchar(500);


SET @PkgName = '%LoadHCRSO%';
--SET @StageName = 'CCRSLoadtoDSDW 8 Ax-Assessment individual record';
--SET @DatabaseName = NULL;
--SET @table_name = '%CCRSOutputControlRecord%';
--SET @IsActive = 1;
-- SET @StageOrder = 1;
--SET @BRId = 112771;
--SET @sql = '%CCRS%';


SELECT DISTINCT
	br.BRId
	,pkg.PkgName
	,stg.StageName
	,stg.StageOrder
	,br.Sequence
	,br.ShortNameOfTest
	,'('+CAST(br.ActionID AS varchar)+') ' + act.ActionName AS ActionIdName
	,br.ActionSQL
	,br.ConditionSQL
	,br.DefaultValue
	,br.SourceObjectPhysicalName
	,br.TargetObjectPhysicalName
	,br.FactTableObjectAttributeName
	,sch.DQMF_ScheduleId
	,pkg.PkgID

	,br.*
FROM dbo.ETL_Package AS pkg
FULL JOIN dbo.DQMF_Schedule AS sch
ON pkg.PkgID = sch.PkgKey
FULL JOIN dbo.DQMF_Stage AS stg
ON sch.StageID = stg.StageID
FULL JOIN dbo.DQMF_BizRuleSchedule AS br_sch
ON sch.DQMF_ScheduleId = br_sch.ScheduleID
AND sch.StageID = stg.StageID
FULL JOIN dbo.DQMF_BizRule AS br
ON br_sch.BRID = br.BRId
FULL JOIN dbo.DQMF_Action AS act
ON br.ActionID = act.ActionID
FULL JOIN dbo.MD_Database AS db
ON db.DatabaseId = br.DatabaseId
WHERE 1=1
AND (@StageOrder IS NULL OR stg.StageOrder = @StageOrder)
AND (@BRId IS NULL OR br.BRId = @BRId)
AND (@IsActive IS NULL OR br.IsActive = @IsActive)
AND (@PkgName IS NULL OR pkg.PkgName LIKE @PkgName)
AND (@StageName IS NULL OR stg.StageName LIKE @StageName)
AND (@DatabaseName IS NULL OR db.DatabaseName LIKE @DatabaseName)
AND (@table_name IS NULL OR (br.SourceObjectPhysicalName LIKE @table_name OR br.TargetObjectPhysicalName LIKE @table_name))
AND (@sql IS NULL OR (br.ActionSQL LIKE @sql OR br.ConditionSQL LIKE @sql OR br.SourceObjectPhysicalName LIKE @sql OR br.TargetObjectPhysicalName LIKE @sql OR br.DefaultValue LIKE @sql))
AND (@by IS NULL OR (br.UpdatedBy LIKE @by OR br.CreatedBy LIKE @by
    OR sch.UpdatedBy LIKE @by OR sch.CreatedBy LIKE @by
    OR pkg.UpdatedBy LIKE @by OR pkg.CreatedBy LIKE @by))
ORDER BY pkg.PkgName, stg.StageOrder, stg.StageName, br.Sequence ASC



SELECT *
FROM dbo.ETL_Package AS pkg
FULL JOIN dbo.DQMF_Schedule AS sch
ON pkg.PkgID = sch.PkgKey
FULL JOIN dbo.DQMF_Stage AS stg
ON sch.StageID = stg.StageID
WHERE 1=1
AND (@PkgName IS NULL OR pkg.PkgName LIKE @PkgName)

