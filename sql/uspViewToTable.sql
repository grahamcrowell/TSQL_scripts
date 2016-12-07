--#region CREATE/ALTER PROC
USE TestLog
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspViewToTable';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspViewToTable
	@viewName varchar(100)
AS
BEGIN
	DECLARE @sql varchar(max) = FORMATMESSAGE('SELECT * INTO x%s FROM %s',@viewName,@viewName)
	RAISERROR(@sql, 0, 1) WITH NOWAIT
	EXEC(@sql)
END
GO
--#endregion CREATE/ALTER PROC
EXEC dbo.uspViewToTable 'abc'
