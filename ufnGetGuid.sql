--#region dbo.ufnGetGuid
USE DSDW
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.ufnGetGuid';
SET @sql = FORMATMESSAGE('CREATE FUNCTION %s() RETURNS uniqueidentifier AS BEGIN DECLARE @return uniqueidentifier RETURN @return END;',@name);

IF OBJECT_ID(@name,'FN') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER FUNCTION dbo.ufnGetGuid(@pParam1 int)
RETURNS uniqueidentifier
AS
BEGIN
	DECLARE @return uniqueidentifier;
	
	RETURN @return;
END
GO
--#endregion dbo.ufnGetGuid


