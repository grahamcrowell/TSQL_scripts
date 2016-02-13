DECLARE @input_name NVARCHAR(128);
SET @input_name = 'CommunityMart.dbo.ReferralFact';
-- SET @input_name = 'dbo.ReferralFact';
-- SET @input_name = 'Referralact';
-- SET @input_name = 'ReferralFact';
-- SET @input_name = 'DSDW.Community.ReferralFact';
--GO
DECLARE @counts BIT = 1;
DECLARE @example_values BIT = 1;
--CREATE PROC uspTableInfo
--	@input_name nvarchar(128)
--AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @sql NVARCHAR(MAX);
	DECLARE @param NVARCHAR(MAX);
	DECLARE @message NVARCHAR(500);
	DECLARE @object_id INT = OBJECT_ID(@input_name);
	DECLARE @database_name NVARCHAR(128);
	DECLARE @schema_name NVARCHAR(128);
	DECLARE @table_name NVARCHAR(128);
	DECLARE @full_name NVARCHAR(128);
	DECLARE @table_count int;
	/* validate @input_name */
	IF @object_id IS NULL
	BEGIN
		SET @message = FORMATMESSAGE('@input_name = "%s" is not a valid table', @input_name);
		RAISERROR (@message,1,1);
		RETURN
	END
	/* was a database specified? */
	SET @table_name = PARSENAME(@input_name, 1)
	SET @schema_name = PARSENAME(@input_name, 2)
	SET @database_name = PARSENAME(@input_name, 3)
	IF @schema_name IS NULL
	BEGIN
		SET @schema_name = OBJECT_SCHEMA_NAME(@object_id)
	END
	IF @database_name IS NULL
	BEGIN
		SET @database_name = DB_NAME()
	END
	SET @full_name = @database_name+'.'+@schema_name+'.'+@table_name;
	/* get row count of table */
	SET @sql = 'SELECT @table_countOUT=COUNT(*) FROM '+@full_name
	SET @param = '@table_countOUT int OUT';
	EXEC sp_executesql 
		@sql,
		@param,
		@table_countOUT = @table_count OUT;
	SELECT @database_name AS [Database]
		,@schema_name AS [Schema]
		,@table_name AS [Table]
		,@table_count AS [RowCount]

	DECLARE @column_name nvarchar(128);
	DECLARE @column_type nvarchar(128);
	IF OBJECT_ID('tempdb..#summary') IS NOT NULL
		DROP TABLE #summary;
	CREATE TABLE #summary (
		ColumnName nvarchar(128)
		,ColumnType nvarchar(128)
		,DistinctCount int
		,NULLCount int
	);

	INSERT INTO #summary (ColumnName, ColumnType)
	SELECT col.NAME AS column_name
		,typ.NAME AS type_name
	FROM sys.schemas AS sch
	INNER JOIN sys.tables AS tab
		ON sch.schema_id = tab.schema_id
	INNER JOIN sys.columns AS col
		ON tab.object_id = col.object_id
	INNER JOIN sys.types AS typ
		ON col.system_type_id = typ.system_type_id
	WHERE tab.object_id = @object_id
	ORDER BY col.column_id ASC;

	IF @counts = 1 OR @example_values = 1
	BEGIN
		DECLARE col_cur CURSOR
		FOR 
		SELECT ColumnName, ColumnType FROM #summary;

		OPEN col_cur;

		FETCH NEXT FROM col_cur INTO @column_name, @column_type;

		WHILE @@FETCH_STATUS = 0
		BEGIN
			PRINT @column_name
			/* populate count columns */
			IF @counts = 1
			BEGIN
				SET @sql = 'UPDATE #summary
				SET DistinctCount = calc.DistinctCount
					,NULLCount = calc.NULLCount
				FROM #summary AS sum_tab
				INNER JOIN (
					SELECT 
						'''+@column_name+''' AS ColumnName
						,SUM(CASE WHEN '+@column_name+' IS NULL THEN 1 ELSE 0 END) AS NULLCount
						,COUNT(DISTINCT '+@column_name+') AS DistinctCount
					FROM '+@full_name+'
				) calc
				ON calc.ColumnName = sum_tab.ColumnName';
				EXEC(@sql);
			END
			/* populate example values columns */
			IF @example_values = 1
			BEGIN
				ALTER TABLE #summary ADD ExampleValue1 nvarchar(128);
				ALTER TABLE #summary ADD ExampleValue2 nvarchar(128);
				ALTER TABLE #summary ADD ExampleValue3 nvarchar(128);
				SET @sql = 'UPDATE #summary
				SET ExampleValue1 = subpvt.[1]
					,ExampleValue2 = subpvt.[2]
					,ExampleValue3 = subpvt.[3]
				FROM #summary AS sum_tab
				INNER JOIN (
					SELECT '''+@column_name+''' AS ColumnName, pvt.[1], pvt.[2], pvt.[3]
					FROM (
						SELECT value, ROW_NUMBER() OVER(ORDER BY value) AS row_num FROM (SELECT DISTINCT TOP 3 '+@column_name+' AS value FROM '+@full_name+') AS sub
					) AS sel
					PIVOT
					(
						MAX(value)
						FOR row_num IN ([1], [2], [3])
					) AS pvt
				) AS subpvt
				ON subpvt.ColumnName = sum_tab.ColumnName';
				EXEC(@sql);
			END
			FETCH NEXT FROM col_cur INTO @column_name, @column_type;
		END
		CLOSE col_cur;
		DEALLOCATE col_cur;
	END
END


SELECT *
FROM #summary;