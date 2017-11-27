--#region CREATE/ALTER PROC
USE DQMF
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspClean';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspClean
	@pPkgName varchar(100) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	IF @pPkgName IS NULL
	BEGIN
		RAISERROR('USAGE: dbo.uspClean @pPkgName = <package name>',0,1) WITH NOWAIT;
		RETURN 0;
	END 
	RAISERROR('dbo.uspClean ETL_Package: %s',0,1,@pPkgName) WITH NOWAIT;
	DECLARE @cnt int = 0;
	SELECT @cnt=COUNT(*) FROM dbo.ETL_Package WHERE PkgName LIKE @pPkgName;
	IF @cnt = 0
	BEGIN 
		RAISERROR('Package does not exist.',0,1) WITH NOWAIT;
		RETURN @cnt;
	END
	ELSE IF @cnt > 1
	BEGIN
		RAISERROR('Multiple packages exist.',0,1) WITH NOWAIT;
		RETURN @cnt;
	END
	ELSE IF 
		(
			(EXISTS(SELECT *
				FROM DQMF_BizRule AS br
				JOIN dbo.DQMF_BizRuleSchedule AS br_sch
				ON br.BRId = br_sch.BRID
				JOIN dbo.DQMF_Schedule AS sch
				ON br_sch.ScheduleID = sch.DQMF_ScheduleId
				JOIN dbo.DQMF_Stage AS stg
				ON sch.StageID = stg.StageID
				JOIN dbo.ETL_Package AS etl
				ON sch.PkgKey = etl.PkgID
				WHERE etl.PkgName = @pPkgName
				AND CHARINDEX('gcrowell',br.CreatedBy,1) = 0))
			OR (EXISTS(SELECT *
				FROM dbo.DQMF_Schedule AS sch
				JOIN dbo.ETL_Package AS etl
				ON sch.PkgKey = etl.PkgID
				WHERE etl.PkgName = @pPkgName
				AND CHARINDEX('gcrowell',sch.CreatedBy,1) = 0))
		)
		BEGIN
			RAISERROR('not yours to delete!',0,1,@@ROWCOUNT) WITH NOWAIT;
		END
	ELSE
		BEGIN
			DELETE DQMF_BizRule
			-- SELECT *
			FROM DQMF_BizRule AS br
			JOIN dbo.DQMF_BizRuleSchedule AS br_sch
			ON br.BRId = br_sch.BRID
			JOIN dbo.DQMF_Schedule AS sch
			ON br_sch.ScheduleID = sch.DQMF_ScheduleId
			JOIN dbo.DQMF_Stage AS stg
			ON sch.StageID = stg.StageID
			JOIN dbo.ETL_Package AS etl
			ON sch.PkgKey = etl.PkgID
			WHERE etl.PkgName = @pPkgName
			AND CHARINDEX('gcrowell',br.CreatedBy,1) >= 1
			RAISERROR('%i DQMF_BizRule deleted',0,1,@@ROWCOUNT) WITH NOWAIT;

			DELETE DQMF_BizRuleSchedule
			-- SELECT *
			FROM dbo.DQMF_BizRuleSchedule AS br_sch
			JOIN dbo.DQMF_Schedule AS sch
			ON br_sch.ScheduleID = sch.DQMF_ScheduleId
			JOIN dbo.DQMF_Stage AS stg
			ON stg.StageID = sch.StageID
			JOIN dbo.ETL_Package AS etl
			ON sch.PkgKey = etl.PkgID
			WHERE etl.PkgName = @pPkgName
			RAISERROR('%i DQMF_BizRuleSchedule deleted',0,1,@@ROWCOUNT) WITH NOWAIT;

			DELETE DQMF_Stage
			-- SELECT *
			FROM dbo.DQMF_Stage AS stg
			JOIN dbo.DQMF_Schedule AS sch
			ON stg.StageID = sch.StageID
			JOIN dbo.ETL_Package AS etl
			ON sch.PkgKey = etl.PkgID
			WHERE etl.PkgName = 'CCRSXml'
			RAISERROR('%i DQMF_Stage deleted',0,1,@@ROWCOUNT) WITH NOWAIT;

			DELETE DQMF_Schedule
			-- SELECT *
			FROM dbo.DQMF_Schedule AS sch
			JOIN dbo.ETL_Package AS etl
			ON sch.PkgKey = etl.PkgID
			WHERE etl.PkgName = @pPkgName
			AND CHARINDEX('gcrowell',sch.CreatedBy,1) >= 1
			RAISERROR('%i DQMF_Schedule deleted',0,1,@@ROWCOUNT) WITH NOWAIT;
		END
END
GO
--#endregion CREATE/ALTER PROC
EXEC dbo.uspClean @pPkgName = 'CCRSXml';
EXEC dbo.uspClean;


