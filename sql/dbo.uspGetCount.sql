--http://stackoverflow.com/questions/12625729/sql-server-count-number-of-distinct-values-in-each-column-of-a-table

USE AWDW
GO

IF OBJECT_ID('dbo.uspGetCount','P') IS NULL
BEGIN 
	EXEC('CREATE PROC dbo.uspGetCount AS ');
END
GO
ALTER PROC dbo.uspGetCount 
	@table_name nvarchar(128)
AS
BEGIN
	DECLARE @sql nvarchar(max);
	SELECT @sql=REVERSE(STUFF(REVERSE((SELECT 'SELECT ''' + name 
                                     + ''' AS [Column], COUNT(DISTINCT(' 
                                     + QUOTENAME(name) + ')) AS [DistinctCount], SUM(CASE WHEN '
									 + QUOTENAME(name)+' IS NULL THEN 1 ELSE 0 END) AS [NullCount] FROM ' 
                                     + QUOTENAME(@table_name) + ' UNION ' 
                              -- get column name from sys.columns  
                              FROM   sys.columns 
                              WHERE  object_id = Object_id(@table_name)
                              -- concatenate result strings with FOR XML PATH
                              FOR XML PATH (''))), 1, 7, ';'));
PRINT @sql;
EXEC(@sql);
END
GO
DECLARE @table_name nvarchar(64) = 'DimCustomer';
EXEC dbo.uspGetCount @table_name;

DECLARE @sql nvarchar(max);
SELECT @sql=REVERSE(STUFF(REVERSE((SELECT 'SELECT ''' + CAST(column_id AS nvarchar(128))+ ''' AS [column_id],'''
									 +  CAST(object_id AS nvarchar(128)) + ''' AS [object_id],'
									 + 'COUNT(DISTINCT(' 
                                     + QUOTENAME(name) + ')) AS [DistinctCount], SUM(CASE WHEN '
									 + QUOTENAME(name)+' IS NULL THEN 1 ELSE 0 END) AS [NullCount] FROM ' 
                                     + QUOTENAME(@table_name) + ' UNION ' 
-- get column name from sys.columns  
FROM sys.columns 
WHERE object_id = Object_id(@table_name)
-- concatenate result strings with FOR XML PATH
FOR XML PATH (''))), 1, 7, ';'));
PRINT @sql;
EXEC(@sql);