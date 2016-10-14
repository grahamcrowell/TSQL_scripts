--#region CREATE/ALTER PROC dbo.uspSelectTop
USE DSDW
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.uspSelectTop';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

RAISERROR(@name, 0, 0) WITH NOWAIT;


IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	EXEC(@sql);
END
GO
ALTER PROC dbo.uspSelectTop
	@pTableViewName varchar(500)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @start datetime2 = GETDATE();
	DECLARE @runtime int = 0;
	DECLARE @fmt nvarchar(4000);
	SELECT @fmt='dbo.uspSelectTop'
	RAISERROR(@fmt, 0, 1) WITH NOWAIT;
	
	DECLARE @sql nvarchar(max);
	DECLARE @param nvarchar(max);
	
	SET @sql = ''
	SET @sql = 'SELECT TOP 1000 * FROM '+@pTableViewName;
	EXEC(@sql)

	SELECT @runtime=DATEDIFF(second, @start, sysdatetime());
	RAISERROR('!dbo.uspSelectTop: runtime: %i seconds', 0, 1, @runtime) WITH NOWAIT;
	RETURN(@runtime);
END
GO
--#endregion CREATE/ALTER PROC dbo.uspSelectTop
EXEC dbo.uspSelectTop 'CommunityMart.dbo.ReferralFact'
