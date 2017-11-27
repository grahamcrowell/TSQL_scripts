--#region CREATE/ALTER PROC dbo.uspDropConstraints
USE AutoTest
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspDropConstraints';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 0, 0) WITH NOWAIT;


IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspDropConstraints
	@pSchemaName varchar(100)
	,@pTableName varchar(100)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt='dbo.uspDropConstraints'
	RAISERROR(@fmt, 0, 1) WITH NOWAIT;
	

	



DECLARE @sql nvarchar(max);
DECLARE @params nvarchar(max);

DECLARE fk_cur CURSOR
FOR
SELECT tab.name AS TableName, fk.name AS ForeignKeyName
FROM sys.foreign_keys AS fk
JOIN sys.tables AS tab
ON fk.parent_object_id = tab.object_id
WHERE tab.name NOT LIKE '%sys%'
AND tab.name = @pTableName
AND OBJECT_SCHEMA_NAME(tab.object_id) = @pSchemaName

OPEN fk_cur;

DECLARE @tb_name varchar(128);
DECLARE @fk_name varchar(128);

FETCH NEXT FROM fk_cur INTO @tb_name, @fk_name;

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @tb_name, @fk_name;

	SET @sql = 'ALTER TABLE '+@pSchemaName+'.'+@tb_name +' DROP CONSTRAINT '+ @fk_name;
	PRINT @sql
	EXEC(@sql);
	FETCH NEXT FROM fk_cur INTO @tb_name, @fk_name;
END
CLOSE fk_cur;
DEALLOCATE fk_cur;


DECLARE kc_cur CURSOR
FOR
SELECT tab.name AS TableName, kc.name AS IndexName
FROM sys.key_constraints AS kc
JOIN sys.tables AS tab
ON kc.parent_object_id = tab.object_id
WHERE tab.name NOT LIKE '%sys%'
AND tab.name = @pTableName
AND OBJECT_SCHEMA_NAME(tab.object_id) = @pSchemaName

OPEN kc_cur;

DECLARE @kc_name varchar(128);

FETCH NEXT FROM kc_cur INTO @tb_name, @kc_name;

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @tb_name, @kc_name;

	SET @sql = 'ALTER TABLE '+@pSchemaName+'.'+@tb_name +' DROP CONSTRAINT '+ @kc_name;
	PRINT @sql
	EXEC(@sql);
	FETCH NEXT FROM kc_cur INTO @tb_name, @kc_name;
END
CLOSE kc_cur;
DEALLOCATE kc_cur;

DECLARE ix_cur CURSOR
FOR
SELECT tab.name AS TableName, idx.name AS IndexName
FROM sys.indexes AS idx
JOIN sys.tables AS tab
ON idx.object_id = tab.object_id
WHERE tab.name NOT LIKE '%sys%'
AND tab.name = @pTableName
AND OBJECT_SCHEMA_NAME(tab.object_id) = @pSchemaName

OPEN ix_cur;

DECLARE @ix_name varchar(128);

FETCH NEXT FROM ix_cur INTO @tb_name, @ix_name;

WHILE @@FETCH_STATUS = 0
BEGIN
	SELECT @tb_name, @ix_name;

	SET @sql = ' DROP INDEX '+ @ix_name+' ON '+@pSchemaName+'.'+@tb_name;
	PRINT @sql
	EXEC(@sql);
	FETCH NEXT FROM ix_cur INTO @tb_name, @ix_name;
END
CLOSE ix_cur;
DEALLOCATE ix_cur;

SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspDropConstraints: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END
GO
--#endregion CREATE/ALTER PROC dbo.uspDropConstraints

EXEC dbo.uspDropConstraints @pSchemaName = 'dbo', @pTableName = 'column_info'
EXEC dbo.uspDropConstraints @pSchemaName = 'dbo', @pTableName = 'server_info'
EXEC dbo.uspDropConstraints @pSchemaName = 'dbo', @pTableName = 'table_info'
EXEC dbo.uspDropConstraints @pSchemaName = 'dbo', @pTableName = 'database_info'
EXEC dbo.uspDropConstraints @pSchemaName = 'dbo', @pTableName = 'table_profile'
