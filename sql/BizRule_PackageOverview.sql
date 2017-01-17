
USE DQMF
GO

DECLARE @PkgName varchar(500) = 'PopulateCommunityMart'

SELECT 
	pkg.PkgName
	,stg.StageName
	,br.Sequence
	,br.ActionID
	,br.ShortNameOfTest
	,br.TargetObjectPhysicalName
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
AND pkg.PkgName = @PkgName
ORDER BY pkg.PkgName
	,stg.StageName
	,br.Sequence
	,br.ActionID
	,br.ShortNameOfTest
