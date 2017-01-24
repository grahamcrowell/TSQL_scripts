USE DQMF
GO

SET NOCOUNT ON;
DECLARE @pPkgName varchar(100) = 'CCRSLoadtoDSDW'
DECLARE @pStgName varchar(100) = 'CCRSLoadtoDSDW 8 Ax-Assessment individual record'
DECLARE @pSourceTable varchar(100) = 'Staging.CCRSRaiRCAssessment'


--#region Get FileExtractKey and PkgExecKey
DECLARE @FileExtractKey int;
SELECT @FileExtractKey = ExtractFileID
FROM DSDW.Staging.CCRSXmlExtract

DECLARE @PkgExecKey int;

EXEC DQMF.dbo.SetAuditPkgExecution
	@pPkgExecKey = null
	,@pParentPkgExecKey = null
	,@pPkgVersionMajor = 1
	,@pPkgVersionMinor  = 2
	,@pPkgName = @pPkgName
	,@pIsProcessStart  = 1
	,@pIsPackageSuccessful  = 0
	,@pPkgExecKeyout  = @PkgExecKey OUTPUT
--#endregion Get FileExtractKey and PkgExecKey


--#region cursor on Bizrule StageOrder = 1
DECLARE @brid int;
DECLARE @seq int;
DECLARE @FileProcesingStatusID int;
DECLARE @br_name varchar(100);
DECLARE @br_count int;

SELECT @br_count = COUNT(*)
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
AND stg.StageName = @pStgName

DECLARE br_cur cursor
FOR
SELECT-- DISTINCT
	br.BRId
	--,pkg.PkgName
	--,stg.StageName
	--,stg.StageOrder
	,br.Sequence
	,br.ShortNameOfTest
	--,'('+CAST(br.ActionID AS varchar)+') ' + act.ActionName AS ActionIdName
	--,br.ActionSQL
	--,br.ConditionSQL
	--,br.DefaultValue
	--,br.SourceObjectPhysicalName
	--,br.TargetObjectPhysicalName
	--,br.FactTableObjectAttributeName
	--,sch.DQMF_ScheduleId
	--,pkg.PkgID
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
AND stg.StageName = @pStgName
--AND pkg.PkgName = @pPkgName
ORDER BY br.Sequence ASC

OPEN br_cur;
--#endregion cursor on Bizrule StageOrder = 1


FETCH NEXT FROM br_cur INTO @brid, @seq, @br_name;

WHILE @@FETCH_STATUS = 0
BEGIN

	SELECT @brid AS BRID, @seq AS Sequence, @br_count AS br_count, @br_name AS BizRuleName;
	RAISERROR( '--ExecDQMFBizRule: @BRID = %i; sequence %i name: %s.', 0, 1, @BRID,@seq, @br_name ) WITH NOWAIT
	--#region IsActive = 0 for all rules
	UPDATE DQMF.dbo.DQMF_BizRule
	SET IsActive = 0
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
	WHERE 1=1 
	AND pkg.PkgName = @pPkgName
	AND stg.StageName = @pStgName
	--#endregion IsActive = 0 for all rules


	--#region IsActive = 1 for this rule
	UPDATE DQMF.dbo.DQMF_BizRule
	SET IsActive = 1
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
	WHERE 1=1 
	AND br.BRId != @brid
	AND pkg.PkgName = @pPkgName
	AND stg.StageName = @pStgName
	AND br.GUID IN (
		SELECT test.GUID
		FROM STDBDECSUP02.DQMF.dbo.DQMF_BizRule AS test
		WHERE test.GUID = br.GUID
		AND test.IsActive = 1
	)
	--#endregion IsActive = 1 for this rule


	--#region Execute Stage: 
	EXEC DSDW.dbo.[ExecDQMFBizRule] 
	@pStageName = @pStgName, 
	@pExtractFileKey = @FileExtractKey,
	@pActionId = 0,
	@pSourceTable = @pSourceTable,
	@pBRId = NULL,
	@Debug = 0

	--#endregion Execute Stage: 

	--SELECT @@ERROR AS error, ERROR_STATE() AS ErrorState



	FETCH NEXT FROM br_cur INTO @brid, @seq, @br_name;


END

CLOSE br_cur;
DEALLOCATE br_cur;

