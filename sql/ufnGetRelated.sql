--#region dbo.ufnGetRelated
USE CommunityMart
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = 'dbo.ufnGetRelated';
SET @sql = FORMATMESSAGE('CREATE FUNCTION %s() RETURNS @return TABLE (RelatedTableName varchar(100)) AS BEGIN RETURN; END;',@name);

IF OBJECT_ID(@name) IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
ALTER FUNCTION dbo.ufnGetRelated(@pTableName varchar(100))
RETURNS @return TABLE (RelatedTableName varchar(100))
AS
BEGIN
	

	RETURN;
END
GO
--#endregion dbo.ufnGetRelated

DECLARE @TableName varchar(100) = 'dbo.PersonFact'

SELECT *
FROM dbo.ufnGetRelated(@TableName)


;WITH dst AS (
	SELECT 
		sch.name AS schema_name, tab.name AS table_name, col.name AS column_name, typ.name AS type_name, col.max_length, tab.object_id
	FROM sys.tables AS tab
	JOIN sys.schemas AS sch
	ON tab.schema_id = sch.schema_id
	JOIN sys.columns AS col
	ON col.object_id = tab.object_id
	JOIN sys.types AS typ
	ON col.user_type_id = typ.user_type_id
	WHERE 1=1
	AND tab.name = PARSENAME(@TableName, 1)
	--UNION ALL
	--SELECT 
	--	sch.name AS schema_name, tab.name AS table_name, col.name AS column_name, typ.name AS type_name, col.max_length, tab.object_id
	--FROM sys.tables AS tab
	--JOIN sys.schemas AS sch
	--ON tab.schema_id = sch.schema_id
	--JOIN sys.columns AS col
	--ON col.object_id = tab.object_id
	--JOIN sys.types AS typ
	--ON col.user_type_id = typ.user_type_id
	--JOIN dst
	--ON tab.name = dst.table_name
	--WHERE 1=1
	--AND sch.name = 'dbo'
), fk AS (
	SELECT 
		sch.name AS schema_name, tab.name AS table_name, col.name AS column_name, typ.name AS type_name, col.max_length, tab.object_id
	FROM sys.tables AS tab
	JOIN sys.schemas AS sch
	ON tab.schema_id = sch.schema_id
	JOIN sys.columns AS col
	ON col.object_id = tab.object_id
	JOIN sys.types AS typ
	ON col.user_type_id = typ.user_type_id
	WHERE 1=1
)
SELECT dst.*
	,fk.*
FROM dst
LEFT JOIN fk
--ON CASE WHEN src.column_name LIKE '%DateID' THEN 'DateID' ELSE src.column_name END = fk.column_name
ON dst.column_name = fk.column_name
AND dst.object_id != fk.object_id
WHERE fk.schema_name = 'Dim'



