USE DQMF
GO

DECLARE @pkg_name varchar(100);
DECLARE @stg_name varchar(100);
SET @stg_name = '%CCRS%'
SET @pkg_name = '%CCRS%'

SELECT 
	COUNT(*) AS row_cnt
	,pkg.PkgName
	,stg.StageID
	,stg.StageName
	,br.Sequence
	,br.ActionID
	,br.ShortNameOfTest
	,br.brid
	,br.ActionSql
	,config.ConfigurationFilter
FROM ETL_Package AS pkg
JOIN DQMF_Schedule AS sch
ON pkg.PkgID = sch.PkgKey
JOIN DQMF_Stage AS stg
ON stg.StageID = sch.StageID
JOIN DQMF_BizRuleSchedule AS br_sch
ON sch.DQMF_ScheduleId = br_sch.ScheduleID
JOIN DQMF_BizRule AS br
ON br_sch.BRID = br.BRId
LEFT JOIN msdb.dbo.SSIS_Config AS config
ON SUBSTRING(config.ConfigurationFilter,1,CASE WHEN CHARINDEX('.',config.ConfigurationFilter,1) = 0 THEN 100 ELSE CHARINDEX('.',config.ConfigurationFilter,1)-1 END) = pkg.PkgName
WHERE br.IsActive = 1
AND stg.StageName = 'CCRSExtract 1 ControlRecord'
GROUP BY pkg.PkgName
	,stg.StageID
	,stg.StageName
	,br.Sequence
	,br.ActionID
	,br.ShortNameOfTest
	,br.brid
	,br.ActionSql
	,config.ConfigurationFilter
ORDER BY pkg.PkgName
	,stg.StageID
	,stg.StageName
	,br.Sequence
	,br.ActionID
	,br.ShortNameOfTest
	,br.brid
	,br.ActionSql
	,config.ConfigurationFilter
