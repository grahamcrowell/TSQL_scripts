USE DQMF
GO



IF OBJECT_ID('dbo.uspColumnHistogram','P') IS NULL
BEGIN 
	DECLARE @sql nvarchar(max) = 'CREATE PROC dbo.uspColumnHistogram @table_name nvarchar(1552) = NULL AS BEGIN RETURN 1; END;'
	EXEC(@sql);
END
GO

ALTER PROC dbo.uspColumnHistogram
	@view_sql varchar(1552) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF;
	DECLARE @database_name sysname;
	DECLARE @schema_name sysname;
	DECLARE @table_name sysname;
	DECLARE @column_name sysname;

	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);

	--SELECT @view_sql AS UserInput;

	SELECT @database_name = ISNULL(PARSENAME(@view_sql, 4), DB_NAME());
	SELECT @schema_name = ISNULL(PARSENAME(@view_sql, 3),'dbo');
	SELECT @table_name = PARSENAME(@view_sql, 2);
	SELECT @column_name = PARSENAME(@view_sql, 1);

	DECLARE @full_table_name varchar(300) = FORMATMESSAGE('%s.%s.%s',@database_name,@schema_name,@table_name);
	--SELECT @full_table_name AS full_table_name;

	--SELECT 
	--	'uspColumnHistogram' AS src
	--	,@database_name AS database_name
	--	,@schema_name AS schema_name
	--	,@table_name AS table_name
	--	,@column_name AS column_name

	DECLARE @object_id int = OBJECT_ID(@full_table_name);
	IF @object_id IS NULL
	BEGIN 
		DECLARE @fmt nvarchar(500) = N'uspColumnHistogram ERROR: ''%s'' is not a valid table.'
		RAISERROR(@fmt, 18,1, @full_table_name);
	END
	
	SET @sql = FORMATMESSAGE(N'SELECT %s, %s,COUNT(*)
	FROM %s
	GROUP BY %s, %s;', @column_name, @table_name, @full_table_name, @column_name, @table_name)
	RAISERROR ('%s', 0, 1, @sql) WITH NOWAIT;
	EXEC(@sql);
END
GO
DECLARE @null_count int 
	,@distinct_count int
	,@zero_count int;
EXEC dbo.uspColumnHistogram 'DQMF.dbo.DQMF_BizRule.StageName';

DECLARE @sql varchar(max) = 'SELECT stg.StageName, db.DatabaseName, br.Brid FROM DQMF.dbo.DQMF_BizRule AS br JOIN S'
GO
--CREATE VIEW vw
--AS
--SELECT stg.StageName, db.DatabaseName, br.Brid 
--FROM DQMF.dbo.DQMF_BizRule AS br 
--JOIN DQMF.dbo.DQMF_BizRuleSchedule AS br_sch 
--ON br.BRId = br_sch.BRID 
--JOIN dqmf_schedule AS sch 
--ON sch.DQMF_ScheduleId = br_sch.ScheduleID
--join DQMF_Stage AS stg
--ON sch.StageID = stg.StageID
--join md_database as db
--on br.DatabaseId = db.DatabaseId
--GO


