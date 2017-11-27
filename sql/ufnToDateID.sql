--#region dbo.ufnToDateID
USE CommunityMart
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.ufnToDateID';
SET @sql = FORMATMESSAGE('CREATE FUNCTION %s() RETURNS int AS BEGIN DECLARE @return int RETURN @return END;',@name);

IF OBJECT_ID(@name,'FN') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER FUNCTION dbo.ufnToDateID(@pDate date)
RETURNS int
AS
BEGIN
	RETURN CAST(CONVERT(varchar(10), @pDate, 112) AS int);
END
GO
--#endregion dbo.ufnToDateID


