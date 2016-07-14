--#region CREATE/ALTER PROC
USE TestLog
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspQueryToView';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspQueryToView
@query varchar(max),
@name varchar(100)
AS
BEGIN
	DECLARE @sql varchar(max);
	SET @sql = FORMATMESSAGE('CREATE VIEW %s AS %s',@name, @query);
	RAISERROR('%s',0,1,@sql) WITH NOWAIT
	EXEC(@sql);
END
GO
--#endregion CREATE/ALTER PROC
EXEC dbo.uspQueryToView 'select * from dsdw.dim.date' , 'abc';
