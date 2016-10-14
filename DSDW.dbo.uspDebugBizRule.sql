USE [DSDW]
GO
/****** Object:  StoredProcedure [dbo].[uspDebugBizRule]    Script Date: 9/27/2016 12:24:00 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROC [dbo].[uspDebugBizRule]
	@pBrId int
	,@debug int = 0
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt='dbo.uspDebugBizRule(@pBrId = %d)'
	RAISERROR(@fmt, 0, 1, @pBrId) WITH NOWAIT;
	
	DECLARE @ShortNameOfTest varchar(500)
		,@CreatedDt date
		,@UpdatedDt date
		,@StageID int
		,@StageName varchar(500)
		,@PkgName varchar(500)
		,@PkgMajorVersion int
		,@PkgMinorVersion int
		,@cnt int
		,@sql varchar(max);

	IF @debug > 0
	BEGIN
		-- show info for given BRid
		SELECT ShortNameOfTest, br.IsActive, br.IsLogged, TargetObjectPhysicalName, TargetObjectAttributePhysicalName, CreatedDT, UpdatedDT
		FROM DQMF.dbo.DQMF_BizRule AS br
		WHERE br.BRId = @pBrId;
	END

	IF @debug > 0
	BEGIN
		-- show all schedules, stages, databases etc associated with given BRid
		SELECT br_sch.ScheduleID, db.DatabaseName, db.IsActive, db.DatabaseId, pkg.PkgName, pkg.isActive, pkg.PkgID, stg.StageName, stg.StageID
		FROM DQMF.dbo.DQMF_BizRuleSchedule AS br_sch
		JOIN DQMF.dbo.DQMF_Schedule AS sch
		ON br_sch.ScheduleID = sch.DQMF_ScheduleId
		JOIN DQMF.dbo.ETL_Package AS pkg
		ON sch.PkgKey = pkg.PkgID
		JOIN DQMF.dbo.MD_Database AS db
		ON sch.DatabaseId = db.DatabaseId
		JOIN DQMF.dbo.DQMF_Stage AS stg
		ON stg.StageID = sch.StageID
		WHERE 1=1
		AND br_sch.BRID = @pBrId
	END

	-- arbitrarily find a stage with given br
	SELECT 
		TOP 1
		@StageName=stg.StageName, @StageID=stg.StageID, @PkgName=pkg.PkgName
	FROM DQMF.dbo.DQMF_BizRuleSchedule AS br_sch
	JOIN DQMF.dbo.DQMF_Schedule AS sch
	ON br_sch.ScheduleID = sch.DQMF_ScheduleId
	JOIN DQMF.dbo.ETL_Package AS pkg
	ON sch.PkgKey = pkg.PkgID
	JOIN DQMF.dbo.MD_Database AS db
	ON sch.DatabaseId = db.DatabaseId
	JOIN DQMF.dbo.DQMF_Stage AS stg
	ON stg.StageID = sch.StageID
	WHERE 1=1
	AND br_sch.BRID = @pBrId
	AND db.IsActive = 1
	AND pkg.isActive = 1

	SET @cnt = @@ROWCOUNT;

	-- make sure stage was found
	IF @cnt = 0
	BEGIN 
		RAISERROR('ERROR: Unable to find stage of BR with Active database and pkg',0,1) WITH NOWAIT;
		SELECT 'ERROR: Unable to find stage of BR with Active database and pkg' AS [-------------- ErrorMessage-----------------];
		RETURN;
	END
	ELSE 
	BEGIN
		RAISERROR('Using Package: %s; Stage: %s (id=%d)',0,1, @PkgName, @StageName, @StageID) WITH NOWAIT;
		SELECT 'Using Stage and Package:' AS info, @StageName AS StageName, @StageID AS StageID, @PkgName AS PkgName
	END

	

	BEGIN TRANSACTION
		-- save current IsActive settings for found stage
		DECLARE @BrIsActive TABLE (Brid int, IsActive bit);

		INSERT INTO @BrIsActive
		SELECT br.Brid, br.IsActive
		FROM DQMF.dbo.DQMF_BizRule AS br
		JOIN DQMF.dbo.DQMF_BizRuleSchedule AS br_sch
		ON br.BRId = br_sch.BRID
		JOIN DQMF.dbo.DQMF_Schedule AS sch
		ON br_sch.ScheduleID = sch.DQMF_ScheduleId
		JOIN DQMF.dbo.DQMF_Stage AS stg
		ON stg.StageID = sch.StageID
		WHERE stg.StageID = @StageID

		SET @cnt = @@ROWCOUNT;
	COMMIT;

	BEGIN TRY
		-- deactivate br's in found stage
		UPDATE DQMF.dbo.DQMF_BizRule
			SET IsActive = 0
		FROM DQMF.dbo.DQMF_BizRule AS br
		JOIN DQMF.dbo.DQMF_BizRuleSchedule AS br_sch
		ON br.BRId = br_sch.BRID
		JOIN DQMF.dbo.DQMF_Schedule AS sch
		ON br_sch.ScheduleID = sch.DQMF_ScheduleId
		JOIN DQMF.dbo.DQMF_Stage AS stg
		ON stg.StageID = sch.StageID
		WHERE stg.StageID = @StageID

		-- activate given br in found stage
		UPDATE DQMF.dbo.DQMF_BizRule
			SET IsActive = 1
		FROM DQMF.dbo.DQMF_BizRule AS br
		WHERE br.BRId = @pBrId

		-- get Pkg Exec info (SetAuditPkgExecution)
		DECLARE @pPkgExecKeyOut int;
		EXEC DQMF.[dbo].[SetAuditPkgExecution]
				@pPkgExecKey  = null
				,@pParentPkgExecKey  = null
				,@pPkgName = @PkgName
				,@pPkgVersionMajor = 1
				,@pPkgVersionMinor = 0
				,@pIsProcessStart = 1
				,@pIsPackageSuccessful = 0
				,@pPkgExecKeyOut = @pPkgExecKeyOut OUTPUT

		-- get Extract File info (SetAuditExtractFile)
		DECLARE @date smalldatetime, @pExtractFileKeyOut int;
		SET @date = getdate()
		EXEC DQMF.[dbo].[SetAuditExtractFile]
				@pPkgExecKey = @pPkgExecKeyOut
				,@pExtractFileKey = null
				,@pExtractFilePhysicalLocation = @PkgName 
				,@pIsProcessStart = 1
				,@pExtractFileCreatedDT = @date
				,@pIsProcessSuccess = 0
				,@pExtractFileKeyOut = @pExtractFileKeyOut OUTPUT
		
		-- tell user what will be executed
		--IF @debug > 0
		BEGIN 
			SELECT FORMATMESSAGE('EXEC DSDW.[dbo].[ExecDQMFBizRule]  @pStageName=''%s'', @pExtractFileKey=%d, @pPkgExecKey=%d',@StageName, @pExtractFileKeyOut, @pPkgExecKeyOut);
			RAISERROR('@pStageName=''%s'', @pExtractFileKey=%d, @pPkgExecKey=%d',0,1,@StageName, @pExtractFileKeyOut, @pPkgExecKeyOut) WITH NOWAIT;
			RAISERROR('EXECUTING BizRule...',0,1) WITH NOWAIT;
		END

		-- Execute found stage using usual DSDW.dbo.ExecDQMFBizRule 
		EXEC DSDW.dbo.ExecDQMFBizRule 
				@pStageName = @StageName
				,@pExtractFileKey = @pExtractFileKeyOut
				,@debug = 10
		
		-- return BizRule rows of found stage to original IsActive state
		UPDATE DQMF.dbo.DQMF_BizRule
			SET IsActive = bkup.IsActive
		FROM DQMF.dbo.DQMF_BizRule AS br
		JOIN @BrIsActive AS bkup
		ON br.BRId = bkup.Brid
	
	END TRY
	BEGIN CATCH
		RAISERROR('ERROR: Unable to find stage of BR with Active database and pkg',0,1) WITH NOWAIT;
		SELECT 'ERROR: Unable to find stage of BR with Active database and pkg' AS [-------------- ErrorMessage-----------------];
		RETURN;
		SELECT  
			ERROR_NUMBER() AS ErrorNumber  
			,ERROR_SEVERITY() AS ErrorSeverity  
			,ERROR_STATE() AS ErrorState  
			,ERROR_PROCEDURE() AS ErrorProcedure  
			,ERROR_LINE() AS ErrorLine  
			,ERROR_MESSAGE() AS ErrorMessage;  
		
		-- return BizRule rows of found stage to original IsActive state
		UPDATE DQMF.dbo.DQMF_BizRule
			SET IsActive = bkup.IsActive
		FROM DQMF.dbo.DQMF_BizRule AS br
		JOIN @BrIsActive AS bkup
		ON br.BRId = bkup.Brid

	END CATCH


	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspDebugBizRule: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END

GO
