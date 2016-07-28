--#region CREATE/ALTER PROC
USE DSDW
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspSelectTopN';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspSelectTopN
	@pUserTableName nvarchar(500)
AS
BEGIN
	DECLARE @sql nvarchar(max);
	DECLARE @TableName nvarchar(200) = PARSENAME(@pUserTableName,1);
	DECLARE @SchemaName nvarchar(200) = ISNULL(PARSENAME(@pUserTableName,2), 'dbo');
	DECLARE @DatabaseName nvarchar(200) = ISNULL(PARSENAME(@pUserTableName,3),DB_NAME());
	RAISERROR(@TableName,0,1) WITH NOWAIT;
	RAISERROR(@SchemaName,0,1) WITH NOWAIT;
	RAISERROR(@DatabaseName,0,1) WITH NOWAIT;

	DECLARE @FullTableName nvarchar(500) = FORMATMESSAGE('%s.%s.%s',@DatabaseName,@SchemaName,@TableName);
	
	SET @sql = FORMATMESSAGE('SELECT TOP %i * FROM %s AS tab',1000, @FullTableName);
	PRINT @sql;
	EXEC(@sql);
END
GO
--#endregion CREATE/ALTER PROC
EXEC dbo.uspSelectTopN 'DQMF.dbo.MD_Object'
EXEC dbo.uspSelectTopN 'dbo.MD_Object'
EXEC dbo.uspSelectTopN 'MD_Object'
