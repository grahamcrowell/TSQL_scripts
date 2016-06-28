USE DQMF
GO

DECLARE @pkg_name varchar(100);
DECLARE @stage_name varchar(100);
DECLARE @database_name varchar(100);
DECLARE @table_name varchar(100);

SET @pkg_name = 'CCRSXml';
SET @stage_name = 'CCRSXml - 1 Xml Tables';
SET @database_name = NULL;
--SET @table_name = '%Contact%';

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
JOIN dbo.DQMF_Schedule AS sch
ON pkg.PkgID = sch.PkgKey
JOIN dbo.DQMF_Stage AS stg
ON sch.StageID = stg.StageID
JOIN dbo.DQMF_BizRuleSchedule AS br_sch
ON sch.DQMF_ScheduleId = br_sch.ScheduleID
AND sch.StageID = stg.StageID
JOIN dbo.DQMF_BizRule AS br
ON br_sch.BRID = br.BRId
JOIN dbo.DQMF_Action AS act
ON br.ActionID = act.ActionID
JOIN dbo.MD_Database AS db
ON db.DatabaseId = br.DatabaseId
WHERE 1=1
--AND br.IsActive = 1
AND (@pkg_name IS NULL OR pkg.PkgName LIKE @pkg_name)
AND (@stage_name IS NULL OR stg.StageName LIKE @stage_name)
AND (@database_name IS NULL OR db.DatabaseName LIKE @database_name)
AND (@table_name IS NULL OR ((br.SourceObjectPhysicalName LIKE @table_name OR br.TargetObjectPhysicalName LIKE @table_name) AND br.ActionID = 0))
--AND br.ActionID = 0
--AND stg.StageOrder = 1
--AND br.BRId = 112771
ORDER BY pkg.PkgName, stg.StageOrder
, stg.StageName, br.Sequence ASC
