USE CommunityMart
GO



IF OBJECT_ID('dbo.uspColumnSummary','P') IS NULL
BEGIN 
	DECLARE @sql nvarchar(max) = 'CREATE PROC dbo.uspColumnSummary @table_name nvarchar(1552) = NULL AS BEGIN RETURN 1; END;'
	EXEC(@sql);
END
GO

ALTER PROC dbo.uspColumnSummary
	@user_input varchar(1552) = NULL
	,@null_count int OUT
	,@distinct_count int OUT
	,@zero_count int OUT
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

	--SELECT @user_input AS UserInput;

	SELECT @database_name = ISNULL(PARSENAME(@user_input, 4), DB_NAME());
	SELECT @schema_name = ISNULL(PARSENAME(@user_input, 3),'dbo');
	SELECT @table_name = PARSENAME(@user_input, 2);
	SELECT @column_name = PARSENAME(@user_input, 1);

	DECLARE @full_table_name varchar(300) = FORMATMESSAGE('%s.%s.%s',@database_name,@schema_name,@table_name);
	--SELECT @full_table_name AS full_table_name;

	--SELECT 
	--	'uspColumnSummary' AS src
	--	,@database_name AS database_name
	--	,@schema_name AS schema_name
	--	,@table_name AS table_name
	--	,@column_name AS column_name

	DECLARE @object_id int = OBJECT_ID(@full_table_name);
	IF @object_id IS NULL
	BEGIN 
		DECLARE @fmt nvarchar(500) = N'uspColumnSummary ERROR: ''%s'' is not a valid table.'
		RAISERROR(@fmt, 18,1, @full_table_name);
	END
	
	SET @sql = FORMATMESSAGE(N'SELECT @null_countOUT = COUNT(*) FROM %s WHERE %s IS NULL;', @full_table_name, @column_name); 
	SET @param = FORMATMESSAGE(N'@null_countOUT int OUT');
	EXEC sp_executesql @sql, @param, @null_countOUT = @null_count OUT;
	RAISERROR('%s',0, 1, @column_name) WITH NOWAIT;

	SET @sql = FORMATMESSAGE(N'SELECT @distinct_countOUT = COUNT(DISTINCT %s) FROM %s;', @column_name, @full_table_name); 
	SET @param = FORMATMESSAGE(N'@distinct_countOUT int OUT');
	EXEC sp_executesql @sql, @param, @distinct_countOUT = @distinct_count OUT;
	RAISERROR('%s',0, 1, @column_name) WITH NOWAIT;

	SET @sql = FORMATMESSAGE(N'SELECT @zero_countOUT = COUNT(*) FROM %s WHERE [%s] = 0;', @full_table_name, @column_name); 
	RAISERROR('%s',0, 1, @sql) WITH NOWAIT;
	SET @param = FORMATMESSAGE(N'@zero_countOUT int OUT');
	RAISERROR('%s',0, 1, @param) WITH NOWAIT;
	EXEC sp_executesql @sql, @param, @zero_countOUT = @zero_count OUT;
	RAISERROR('%s',0, 1, @column_name) WITH NOWAIT;
END
GO
--DECLARE @null_count int 
--	,@distinct_count int
--	,@zero_count int;
--EXEC dbo.uspColumnSummary 'dbo.ReferralFact.SourceReferralID', @null_count OUT, @distinct_count OUT, @zero_count OUT;

--SELECT @null_count AS null_count, @distinct_count AS distinct_count, @zero_count AS zero_count;

IF OBJECT_ID('dbo.uspTableSummary','P') IS NULL
BEGIN 
	DECLARE @sql nvarchar(max) = 'CREATE PROC dbo.uspTableSummary 	@table_name nvarchar(1552) = NULL AS BEGIN SELECT NULL; END;'
	EXEC(@sql);
END
GO

ALTER PROC dbo.uspTableSummary 	
	@user_input varchar(1552) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF;
	PRINT 'Computing summary for: '
	PRINT ''
	RAISERROR ('%s', 0, 1, @user_input) WITH NOWAIT;

	DECLARE @object_id int = ISNULL(OBJECT_ID(@user_input,'U'),OBJECT_ID(@user_input,'V'));
	IF @object_id IS NULL
	BEGIN 
		DECLARE @fmt nvarchar(500) = N'uspTableSummary ERROR: ''%s'' is not a valid table or view.'
		RAISERROR(@fmt, 18,1, @user_input);
	END


	DECLARE @database_name sysname;
	DECLARE @schema_name sysname;
	DECLARE @table_name sysname;
	SELECT @database_name = ISNULL(PARSENAME(@user_input, 3), DB_NAME());
	SELECT @schema_name = ISNULL(PARSENAME(@user_input, 2), 'dbo');
	SELECT @table_name = PARSENAME(@user_input, 1);

	DECLARE @full_table_name nvarchar(300) = FORMATMESSAGE('%s.%s.%s',@database_name,@schema_name,@table_name);
	--SELECT @full_table_name AS full_table_name_uspTableSummary;
	

	--SELECT 
	--	'uspTableSummary' AS src
	--	,@database_name AS database_name
	--	,@schema_name AS schema_name
	--	,@table_name AS table_name

	DECLARE @sql nvarchar(max);

	DECLARE @table_row_count int;
	DECLARE @param nvarchar(500);
	SET @sql = FORMATMESSAGE(N'SELECT @table_row_countOUT = COUNT(*) FROM %s', @full_table_name);
	SET @param = '@table_row_countOUT int OUT';
	EXEC sp_executesql @sql, @param, @table_row_countOUT = @table_row_count OUT;

	SET @sql = FORMAT(@table_row_count, 'N0');
	RAISERROR ('Table Row Count: %s', 0, 1, @sql) WITH NOWAIT;
	PRINT ''


	DECLARE  @table_summary table (
		column_name nvarchar(300)
		,column_type varchar(20)
		,null_count int
		,distinct_count int
		,zero_count int
		,column_id int
	);
	INSERT INTO @table_summary (column_name, column_type, column_id)
	SELECT 
		col.name AS column_name
		,CASE
			WHEN typ.name LIKE '%char%' THEN FORMATMESSAGE('%s(%i)',typ.name, col.max_length)
			ELSE typ.name
		END AS column_type
		,col.column_id
	FROM sys.columns AS col
	JOIN sys.types AS typ
	ON col.system_type_id = typ.system_type_id
	WHERE object_id = @object_id
	ORDER BY col.object_id ASC;

	--SELECT *
	--FROM @table_summary;

	DECLARE cur CURSOR FAST_FORWARD
	FOR 
	SELECT column_name
	FROM @table_summary;

	DECLARE @column_name sysname
		,@null_count int
		,@distinct_count int
		,@zero_count int
	
	OPEN cur;

	FETCH NEXT FROM cur INTO @column_name;
	DECLARE @full_column_name nvarchar(300);
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @full_column_name = @full_table_name+'.'+@column_name
		RAISERROR('hello',0, 1) WITH NOWAIT;
		EXEC dbo.uspColumnSummary @full_column_name, @null_count OUT, @distinct_count OUT, @zero_count OUT;
		RAISERROR('hello',0, 1) WITH NOWAIT;
		--SELECT @null_count AS null_count, @distinct_count AS distinct_count, @zero_count AS zero_count;
		UPDATE @table_summary
		SET null_count = @null_count
			,distinct_count = @distinct_count
			,zero_count = @zero_count
		FROM @table_summary
		WHERE column_name = @column_name;
		RAISERROR ('%-30s null_count: %12i   distinct_count: %12i   zero_count: %12i', 0, 1, @column_name, @null_count, @distinct_count, @zero_count) WITH NOWAIT;

		FETCH NEXT FROM cur INTO @column_name
	END

	CLOSE cur;
	DEALLOCATE cur;

	

	SELECT 
		@database_name AS database_name
		,@schema_name AS schema_name
		,@table_name AS table_name
		,FORMAT(@table_row_count, 'N0') AS table_row_count

	SELECT 
		column_name
		,FORMAT(null_count, 'N0') AS null_count
		,FORMAT(1.*null_count/@table_row_count,'p') AS null_percent
		,FORMAT(distinct_count, 'N0') AS distinct_count
		,FORMAT(1.*distinct_count/@table_row_count,'p') AS distinct_zero
		,FORMAT(zero_count, 'N0') AS zero_count
		,FORMAT(1.*zero_count/@table_row_count,'p') AS zero_percent
	FROM @table_summary
	ORDER BY column_id ASC;
END
GO

EXEC dbo.uspTableSummary 'CommunityMart.dbo.CaseNoteContactFact';
--EXEC dbo.uspTableSummary'dbo.ReferralFact';
--EXEC dbo.uspTableSummary'ReferralFact';
--EXEC dbo.uspTableSummary'DSDW.Community.ReferralFact';



--EXEC sp_columns 'ReferralFact'


--SELECT FORMAT(1.*5/9,'p')




























--SElect Distinct object_name(part.object_id), SUM(rows)
--fROM sys.partitions AS part
--where OBJECT_SCHEMA_NAME(part.object_id) = 'dbo'
--group by part.index_id,object_name(part.object_id)



--SELECT *
--FROM sys.dm_db_stats_properties (object_id('ReferralFact'), 2) as ddsp

--SELECT COUNT(*)
--FROM ReferralFact;

--DBCC SHOW_STATISTICS('ReferralFact','SourceReferralID') WITH HISTOGRAM

--exec sp_MSforeachtable
--@command1=N'SELECT * FROM sys.dm_db_stats_properties (object_id(''?''), 2) as ddsp'
