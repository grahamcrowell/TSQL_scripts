--#region dbo.ufnToDate
USE CommunityMart
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.ufnToDate';
SET @sql = FORMATMESSAGE('CREATE FUNCTION %s() RETURNS datetime2 AS BEGIN DECLARE @return datetime2 RETURN @return END;',@name);

IF OBJECT_ID(@name,'FN') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER FUNCTION dbo.ufnToDate(@pDateID int)
RETURNS datetime2
AS
BEGIN
	RETURN CONVERT(datetime2, CAST(@pDateID AS varchar(8)), 112);
END
GO
--#endregion dbo.ufnToDate


