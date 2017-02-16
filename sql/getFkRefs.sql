USE CommunityMart
GO

DECLARE @TableName VARCHAR(500) = 'CommunityMart.dbo.HonosFact';

WITH src_columns AS (
	SELECT col.name
	FROM CommunityMart.sys.columns AS col
	WHERE 1=1 
	AND OBJECT_NAME(col.object_id) LIKE PARSENAME(@TableName,1)
	AND OBJECT_SCHEMA_NAME(col.object_id) LIKE ISNULL(PARSENAME(@TableName,2),'dbo')

), dst_columns AS (
	SELECT 
		OBJECT_SCHEMA_NAME(col.object_id) AS SchemaName
		,OBJECT_NAME(col.object_id) AS TableName
		,col.name AS ColumnName
	FROM CommunityMart.sys.columns AS col
	JOIN CommunityMart.sys.tables AS tab
	ON tab.object_id = col.object_id
	JOIN src_columns
	ON src_columns.name = col.name
	WHERE 1=1 
	AND OBJECT_SCHEMA_NAME(col.object_id)+'.'+OBJECT_NAME(col.object_id) NOT LIKE ISNULL(PARSENAME(@TableName,2),'dbo')+'.'+PARSENAME(@TableName,1)
)
SELECT *
FROM dst_columns