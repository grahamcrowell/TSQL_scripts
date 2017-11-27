USE CommunityMart
GO

EXEC sp_spaceused @updateusage = N'TRUE';  
GO  

EXEC sp_spaceused N'dbo.ReferralFact';  
GO  

DBCC SHRINKDATABASE (AutoTest, 10);  
GO


SELECT 
    t.NAME AS TableName,
    s.Name AS SchemaName,
    p.rows AS RowCounts,
    SUM(a.total_pages) * 8 AS TotalSpaceKB, 
    SUM(a.used_pages) * 8 AS UsedSpaceKB, 
    (SUM(a.total_pages) - SUM(a.used_pages)) * 8 AS UnusedSpaceMB
FROM 
    sys.tables t
INNER JOIN      
    sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN 
    sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN 
    sys.allocation_units a ON p.partition_id = a.container_id
LEFT OUTER JOIN 
    sys.schemas s ON t.schema_id = s.schema_id
WHERE 
    t.NAME NOT LIKE 'dt%' 
    AND t.is_ms_shipped = 0
    AND i.OBJECT_ID > 255 
GROUP BY 
    t.Name, s.Name, p.Rows
ORDER BY 
    SUM(a.total_pages) DESC



USE AutoTest 
GO

EXEC sp_MSforeachtable @command1 = '
DECLARE @rcount int;

IF OBJECT_SCHEMA_NAME(OBJECT_ID(''?'')) = ''SnapShot'' OR 1=1
BEGIN
	SELECT @rcount=COUNT(*) FROM ?;
	INSERT INTO ##tab VALUES (''?'', @rcount);
END
', @precommand = 'CREATE TABLE ##tab (
	TableName varchar(200)
	,rcount int
);',@postcommand = 'SELECT * FROM ##tab order by rcount desc; DROP TABLE ##tab;'

