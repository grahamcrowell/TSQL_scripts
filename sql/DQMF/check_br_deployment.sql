USE DQMF
GO
select ShortNameOfTest,ActionSQL,STageName,PkgName,scheduleID, guid, IsLogged, br.IsActive
from DQMF.dbo.DQMF_BizRule BR
 left join DQMF.dbo.DQMF_BizRuleSchedule BRS on BR.BRID = BRS.BRID
 left join DQMF.dbo.DQMF_Schedule S on BRS.ScheduleId = S.DQMF_ScheduleId
 left join DQMF.dbo.DQMF_Stage St on S.StageID = St.StageID
 left join DQMF.dbo.ETL_Package P on S.PkgKey = P.PkgID
 left outer join DQMF.dbo.DQMF_BizRuleLookupMapping BRLM on BR.BRID = BRLM.BRID
where STageName like 'Communitymart post process'
and GUID='5BF660FF-79FA-4527-916C-907D98CA0469'

USE DQMF
GO
DECLARE @PkgName varchar(100), @PkgDescription varchar(max),@PkgKey int, @PkgID int, @DQMF_ScheduleId INT, @StageID INT 
DECLARE @ActionSQL varchar(MAX), @CreatedBy varchar(100), @UpdatedBy varchar(100) 
DECLARE @StageName varchar(100), @StageDescription  varchar(max)
DECLARE @StageOrder  smallint
DECLARE @DatabaseId int
DECLARE @TableId int 
DECLARE @IsScheduleActive bit
DECLARE @IsActive bit
DECLARE @IsLogged bit
DECLARE @BRID INT
DECLARE @GUID nvarchar(40)

SET @PkgName ='PopulateCommunityMart'
 
SET @PkgDescription ='PopulateCommunityMart'
SET @CreatedBy ='VCH\DCampbell2'
SET @UpdatedBy = 'VCH\GCrowell'


SELECT @PkgId = PkgId, @PkgKey=PkgId FROM dbo.ETL_Package WHERE PkgName=@PkgName 
SET @DatabaseId = 32
SET @TableId = 0
SET @IsScheduleActive = 1
SET @CreatedBy = 'VCH\DCampbell2'
SET @UpdatedBy = 'VCH\DCampbell2'
SET @StageName= 'CommunityMart Post Process'
SET @StageDescription= 'CommunityMart Post Process'
SET @StageOrder= 100
SET @StageID = NULL
SET @DQMF_ScheduleId = NULL
SELECT @StageID=StageID FROM dbo.DQMF_Stage WHERE StageName =@StageName 
SELECT @DQMF_ScheduleId = Sch.DQMF_ScheduleId 
FROM DQMF_Schedule Sch INNER JOIN dbo.DQMF_Stage Stage ON Sch.StageID=Stage.StageID
INNER JOIN dbo.ETL_Package Pkg ON Sch.PkgKey=Pkg.PkgID
WHERE StageName = @StageName 

 
/* This script will try to re-get all variables */
 
SELECT @DatabaseId = Sch.DatabaseId, @TableId=Sch.TableID, @IsScheduleActive=Sch.IsScheduleActive, @CreatedBy = Sch.CreatedBy, @UpdatedBy=Sch.UpdatedBy, @StageID = Stage.StageID, @StageDescription = Stage.StageDescription, @StageOrder = Stage.StageOrder, @DQMF_ScheduleId = Sch.DQMF_ScheduleId 
	FROM DQMF_Schedule Sch INNER JOIN dbo.DQMF_Stage Stage ON Sch.StageID=Stage.StageID
	INNER JOIN dbo.ETL_Package Pkg ON Sch.PkgKey=Pkg.PkgID
	WHERE StageName = @StageName 
 

 SET @GUID = '5BF660FF-79FA-4527-916C-907D98CA0469';
SELECT * FROM dbo.DQMF_BizRule WHERE GUID=@GUID
 SET @GUID = '5BF660FF-79FA-4527-916C-907D98CA0469';
SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID)