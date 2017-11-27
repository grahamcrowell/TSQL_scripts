USE DQMF
GO
DECLARE @pPkgName varchar(100);
DECLARE @StageName varchar(500);
SET @StageName= 'CommunityMart Post Process'
SET @pPkgName = 'PopulateCommunityMart';
--EXEC dbo.ExecPackagebyStageName @pPkgName, @StageName



DECLARE @pPkgExecKeyOut int;
EXEC [dbo].[SetAuditPkgExecution]
			@pPkgExecKey  = null
			,@pParentPkgExecKey  = null
			,@pPkgName = @pPkgName
			,@pPkgVersionMajor = 1
			,@pPkgVersionMinor = 0
			,@pIsProcessStart = 1
			,@pIsPackageSuccessful = 0
			,@pPkgExecKeyOut = @pPkgExecKeyOut OUTPUT

DECLARE @date smalldatetime
	,@pExtractFileKeyOut int;
SET @date = getdate()
EXEC [dbo].[SetAuditExtractFile]
			@pPkgExecKey = @pPkgExecKeyOut
			,@pExtractFileKey = null
			,@pExtractFilePhysicalLocation = @pPkgName 
			,@pIsProcessStart = 1
			,@pExtractFileCreatedDT = @date
			,@pIsProcessSuccess = 0
			,@pExtractFileKeyOut = @pExtractFileKeyOut OUTPUT

EXEC DSDW.[dbo].[ExecDQMFBizRule] 
				@pStageName = @StageName
			,@pExtractFileKey = @pExtractFileKeyOut
			,@debug = 10 -- output [ExecDQMFBizRule]

