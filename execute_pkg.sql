USE DQMF
GO
DECLARE @PkgName VARCHAR(100)
	,@PkgDescription VARCHAR(max)
	,@PkgKey INT
	,@PkgID INT
	,@DQMF_ScheduleId INT
	,@StageID INT
DECLARE @ActionSQL VARCHAR(MAX)
	,@CreatedBy VARCHAR(100)
	,@UpdatedBy VARCHAR(100)
DECLARE @StageName VARCHAR(100)
	,@StageDescription VARCHAR(max)
DECLARE @StageOrder SMALLINT
DECLARE @DatabaseId INT
DECLARE @TableId INT
DECLARE @IsScheduleActive BIT
DECLARE @BRID INT
DECLARE @GUID NVARCHAR(40)
SET @PkgName = 'PopulateCommunityMart'
SET @PkgDescription = 'PopulateCommunityMart'
SET @CreatedBy = 'VCH\DCampbell2'
SET @UpdatedBy = 'VCH\DCampbell2'
SELECT @PkgId = PkgId
	,@PkgKey = PkgId
FROM dbo.ETL_Package
WHERE PkgName = @PkgName
SET @DatabaseId = 32
SET @TableId = 0
SET @IsScheduleActive = 1
SET @CreatedBy = 'VCH\DCampbell2'
SET @UpdatedBy = 'VCH\DCampbell2'
SET @StageName = 'CommunityMart Post Process'
SET @StageDescription = 'CommunityMart Post Process'
SET @StageOrder = 100
SET @StageID = NULL
SET @DQMF_ScheduleId = NULL


/* get Brid of deployed business rule */
SELECT
	--defaultvalue,
	----brs.*,'',sc.*,'',
	--br.isactive,br.comment,
	br.guid
	,p.PkgName
	,s.StageOrder
	,StageName
	,br.*
	,brlm.*
FROM dbo.ETL_Package p
INNER JOIN DQMF.dbo.DQMF_Schedule sc
	ON p.PKGID = sc.PkgKey
INNER JOIN DQMF.dbo.DQMF_Stage s
	ON sc.StageID = s.StageID
LEFT JOIN [dbo].[DQMF_BizRuleSchedule] brs
	ON sc.DQMF_ScheduleId = brs.ScheduleId
LEFT JOIN [dbo].[DQMF_BizRule] br
	ON brs.BRID = br.BRID
LEFT JOIN DQMF.dbo.DQMF_BizRuleLookupMapping brlm
	ON br.BRId = brlm.BRId
WHERE p.PkgName = 'PopulateCommunityMart'



SELECT @StageID = StageID
FROM dbo.DQMF_Stage
WHERE StageName = @StageName
SELECT @DQMF_ScheduleId = Sch.DQMF_ScheduleId
FROM DQMF_Schedule Sch
INNER JOIN dbo.DQMF_Stage Stage
	ON Sch.StageID = Stage.StageID
INNER JOIN dbo.ETL_Package Pkg
	ON Sch.PkgKey = Pkg.PkgID
WHERE StageName = @StageName
--EXECUTE [DQMF].[dbo].[SetStageSchedule] 
--   @pStageID=@StageID
--  ,@pStageName=@StageName
--  ,@pStageDescription=@StageDescription
--  ,@pStageOrder=@StageOrder
--  ,@pDQMF_ScheduleId=@DQMF_ScheduleId
--  ,@pDatabaseId=@DatabaseId
--  ,@pTableId=@TableId
--  ,@pPkgKey=@PkgKey
--  ,@pIsScheduleActive=@IsScheduleActive
--  ,@pCreatedBy=@CreatedBy
--  ,@pUpdatedBy=@UpdatedBy
EXEC DSDW.dbo.[ExecDQMFBizRule] @pStageName = @StageName
	,@pExtractFileKey = - 1
	,@pBRid = 117483
	,@debug = 10
