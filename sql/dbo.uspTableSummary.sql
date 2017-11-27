USE [DSDW]
GO

/****** Object:  StoredProcedure [dbo].[uspTableSummary]    Script Date: 7/5/2016 6:54:10 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


ALTER PROC [dbo].[uspTableSummary] 	
	@user_input varchar(1552) = NULL
	,@Debug int = 0
AS
BEGIN
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF;
	DECLARE @fmt nvarchar(500);

	-- break up user input into parts, fill in missing parts with defaults
	DECLARE @database_name sysname;
	DECLARE @schema_name sysname;
	DECLARE @table_name sysname;
	IF PARSENAME(@user_input, 3) IS NULL
	BEGIN 
		SET @fmt = N'uspTableSummary WARNING: no database specified default is current database: '''+DB_NAME()+'''';
		RAISERROR(@fmt, 0,0) WITH NOWAIT;
		SELECT @database_name = DB_NAME();
	END
	ELSE
		SELECT @database_name = PARSENAME(@user_input, 3);

	IF PARSENAME(@user_input, 2) IS NULL
	BEGIN 
		SET @fmt = N'uspTableSummary WARNING: no schema specified default is ''dbo''';
		RAISERROR(@fmt, 0,0) WITH NOWAIT;
		SELECT @schema_name = 'dbo';
	END
	ELSE
		SELECT @schema_name = PARSENAME(@user_input, 2);
	
	SELECT @table_name = PARSENAME(@user_input, 1);


	--PRINT @database_name;
	--PRINT @schema_name;
	--PRINT @table_name;

	--SELECT OBJECT_SCHEMA_NAME(object_id, DB_ID(@database_name)), *
	--FROM DSDW.sys.tables AS tab
	--WHERE tab.name = @table_name
	--AND OBJECT_SCHEMA_NAME(object_id, DB_ID(@database_name)) = @schema_name

	DECLARE @full_table_name nvarchar(300) = FORMATMESSAGE('%s.%s.%s',@database_name,@schema_name,@table_name);

	DECLARE @object_id int = OBJECT_ID(@full_table_name);
	IF @object_id IS NULL
	BEGIN 
		SET @fmt = N'uspTableSummary ERROR: object with name ''%s'' does not exist on server ''%s'''
		RAISERROR(@fmt, 18,1, @full_table_name, @@SERVERNAME) WITH NOWAIT;
	END
	
	DECLARE @sql nvarchar(max);

	DECLARE @table_row_count int;
	DECLARE @param nvarchar(500);

	SET @sql = FORMATMESSAGE(N'SELECT @table_row_countOUT = COUNT(*) FROM %s', @full_table_name);
	SET @param = '@table_row_countOUT int OUT';
	EXEC sp_executesql @sql, @param, @table_row_countOUT = @table_row_count OUT;

	SET @sql = FORMAT(@table_row_count, 'N0');
	RAISERROR ('Table Row Count: %s', 0, 1, @sql);
	PRINT ''

	IF OBJECT_ID('tempdb..#table_summary_counts','U') IS NOT NULL
	BEGIN
		DROP TABLE #table_summary_counts;
	END

	CREATE TABLE #table_summary_counts 
	(
		column_name nvarchar(300)
		,column_type varchar(20)
		,null_count int
		,distinct_count int
		,zero_count int
		,column_id int
	);


	SET @sql = N'
	INSERT INTO #table_summary_counts (column_name, column_type, column_id)
	SELECT 
		col.name AS column_name
		,CASE
			WHEN typ.name LIKE ''%char%'' AND col.max_length = -1 THEN FORMATMESSAGE(''%s(MAX)'',typ.name, col.max_length)
			WHEN typ.name LIKE ''%char%'' THEN FORMATMESSAGE(''%s(%i)'',typ.name, col.max_length)
			ELSE typ.name
		END AS column_type
		,col.column_id
	FROM '+@database_name+'.sys.columns AS col
	JOIN '+@database_name+'.sys.types AS typ
	ON col.system_type_id = typ.system_type_id
	WHERE object_id = '+CAST(@object_id AS varchar(10))+'
	ORDER BY col.object_id ASC;'

	EXEC(@sql);

	IF @Debug > 0
	SELECT * FROM #table_summary_counts;

	DECLARE cur CURSOR FAST_FORWARD
	FOR 
	SELECT column_name, column_type
	FROM #table_summary_counts;

	DECLARE 
		@column_name sysname
		,@column_type sysname
		,@null_count int
		,@distinct_count int
		,@zero_count int
	
	OPEN cur;

	FETCH NEXT FROM cur INTO @column_name, @column_type;
	DECLARE @full_column_name nvarchar(300);
	WHILE @@FETCH_STATUS = 0
	BEGIN
		SELECT @null_count = NULL, @distinct_count = NULL, @zero_count = NULL;
		IF @column_type NOT IN ('xml')
		BEGIN
			SET @full_column_name = @full_table_name+'.'+@column_name
			EXEC dbo.uspColumnSummary @full_column_name, @null_count OUT, @distinct_count OUT, @zero_count OUT;
		END
		--SELECT  @full_column_name AS full_column_name, @null_count AS null_count, @distinct_count AS distinct_count, @zero_count AS zero_count;
		UPDATE #table_summary_counts
		SET null_count = @null_count
			,distinct_count = @distinct_count
			,zero_count = @zero_count
		FROM #table_summary_counts
		WHERE column_name = @column_name;
		RAISERROR ('%-30s null_count: %12i   distinct_count: %12i   zero_count: %12i', 0, 1, @column_name, @null_count, @distinct_count, @zero_count) WITH NOWAIT;

		FETCH NEXT FROM cur INTO @column_name, @column_type;
	END

	CLOSE cur;
	DEALLOCATE cur;

	SELECT 
		@database_name AS database_name
		,@schema_name AS schema_name
		,@table_name AS table_name
		,FORMAT(@table_row_count, 'N0') AS table_row_count
	
	DECLARE @null_percent decimal(3,1)
		,@distinct_percent decimal(3,1)
		,@zero_percent decimal(3,1)

	IF @table_row_count > 0
	BEGIN
		SET @null_percent = 1.*@null_count/@table_row_count;
		SET @distinct_percent = 1.*@distinct_count/@table_row_count;
		SET @zero_percent = 1.*@zero_count/@table_row_count;
	END

	SELECT 
		column_name
		,column_type
		,FORMAT(null_count, 'N0') AS null_count
		,FORMAT(CASE WHEN @table_row_count = 0 THEN NULL ELSE 1.*null_count/@table_row_count END,'p') AS null_percent
		,FORMAT(distinct_count, 'N0') AS distinct_count
		,FORMAT(CASE WHEN @table_row_count = 0 THEN NULL ELSE 1.*distinct_count/@table_row_count END,'p') AS distinct_zero
		,FORMAT(zero_count, 'N0') AS zero_count
		,FORMAT(CASE WHEN @table_row_count = 0 THEN NULL ELSE 1.*zero_count/@table_row_count END,'p') AS zero_percent
	FROM #table_summary_counts
	ORDER BY column_id ASC;

	IF OBJECT_ID('tempdb..#table_summary_counts','U') IS NOT NULL
	BEGIN
		DROP TABLE #table_summary_counts;
	END

	SET @sql = FORMATMESSAGE('SELECT TOP 10 * FROM %s', @full_table_name);
	EXEC(@sql);
END

GO


