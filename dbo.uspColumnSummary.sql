USE [DSDW]
GO
/****** Object:  StoredProcedure [dbo].[uspColumnSummary]    Script Date: 7/7/2016 7:55:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROC [dbo].[uspColumnSummary]
	@user_input varchar(1552) = NULL
	,@null_count int OUT
	,@distinct_count int OUT
	,@zero_count int OUT
AS
BEGIN
	SET NOCOUNT ON;
	SET ANSI_WARNINGS OFF;
	RAISERROR ('Table Row Count: %s', 0, 1, @user_input) WITH NOWAIT;
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
	DECLARE @fmt nvarchar(500);

	IF @database_name != DB_NAME()
	BEGIN
		SET @fmt = N'uspColumnSummary ERROR: change current database connection to ''%s''.'
		--RAISERROR(@fmt, 18,1, @database_name);
	END

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
		SET @fmt = N'uspColumnSummary ERROR: ''%s'' is not a valid table.'
		RAISERROR(@fmt, 18,1, @full_table_name);
	END
	
	SET @sql = FORMATMESSAGE(N'SELECT @null_countOUT = COUNT(*) FROM %s WHERE %s IS NULL;', @full_table_name, @column_name); 
	SET @param = FORMATMESSAGE(N'@null_countOUT int OUT');
	EXEC sp_executesql @sql, @param, @null_countOUT = @null_count OUT;

	SET @sql = FORMATMESSAGE(N'SELECT @distinct_countOUT = COUNT(DISTINCT %s) FROM %s;', @column_name, @full_table_name); 
	SET @param = FORMATMESSAGE(N'@distinct_countOUT int OUT');
	EXEC sp_executesql @sql, @param, @distinct_countOUT = @distinct_count OUT;

	SET @sql = FORMATMESSAGE(N'SELECT @zero_countOUT = COUNT(*) FROM %s WHERE CAST(%s AS varchar(100))= ''0'';', @full_table_name, @column_name); 
	SET @param = FORMATMESSAGE(N'@zero_countOUT int OUT');
	EXEC sp_executesql @sql, @param, @zero_countOUT = @zero_count OUT;
END

GO
