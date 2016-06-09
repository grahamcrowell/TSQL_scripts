USE DQMF
GO

DECLARE @pkg_name varchar(100);
DECLARE @stage_name varchar(100);
DECLARE @database_name varchar(100);
DECLARE @table_name varchar(100);

SET @pkg_name = '%CCRS%';
SET @stage_name = NULL;
SET @database_name = 'DSDW';
SET @table_name = NULL;

SELECT DISTINCT
	pkg.PkgName
	,sch.DQMF_ScheduleId
	,stg.StageName
	,stg.StageID
	,br.Sequence
	,br.ShortNameOfTest
	,br.ActionID
	,act.ActionName
	,br.ActionSQL
	,br.ConditionSQL
	,br.SourceObjectPhysicalName
	,br.TargetObjectPhysicalName
	,br.FactTableObjectAttributeName
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
AND br.IsActive = 1
AND (@pkg_name IS NULL OR pkg.PkgName LIKE @pkg_name)
AND (@stage_name IS NULL OR stg.StageName LIKE @stage_name)
AND (@database_name IS NULL OR db.DatabaseName LIKE @database_name)
AND (@table_name IS NULL 
		OR br.SourceObjectPhysicalName LIKE @table_name
		OR br.TargetObjectPhysicalName LIKE @table_name
)
ORDER BY pkg.PkgName, stg.StageName, br.Sequence ASC

----ActionID = 0 -> lookup
---- = 1 -> identify bad records:
---- = 2 -> identify bad records: 
--	--conditionSQL not null
--	--actionsql is null
--	--sourceobject is null
--	--targetobject is Staging
---- = 4 -> update, delete records:
--	--conditional sql is null
--	--action sql is not null
--	--source object is ~ not
--	--destination object is ~ not
--SELECT *
--FROM DQMF.dbo.DQMF_BizRule AS br
----JOIN DQMF.dbo.DQMF_BizRuleLookupMapping AS lkup
----ON br.BRId = lkup.BRId
--WHERE 1=1 
----and br.ActionID = 4
--and br.IsActive = 1
----and br.TargetObjectPhysicalName = '%Community%'
--and br.DatabaseId = 32
--ORDER BY CreatedDT DESC;



----USE DSDW
----GO

----SELECT *
----FROM sys.columns as col
----join sys.tables as tab
----on col.object_id = tab.object_id
----where tab.name = 'AdmissionStageLG';