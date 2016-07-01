USE [DSDW]
GO

IF  NOT EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'dbo.ufnGetColumns'))
BEGIN
	PRINT 'dne'
	EXEC ('CREATE FUNCTION dbo.ufnGetColumns() RETURNS TABLE AS RETURN (SELECT 1 AS col);');
END
GO

ALTER FUNCTION dbo.ufnGetColumns(@pObjectName varchar(255))
RETURNS TABLE
AS
RETURN 
(
	SELECT TOP 100 PERCENT 
		col.name AS column_name
		,typ.name AS type_name
		,col.is_nullable
		,CASE WHEN typ.name LIKE '%char%' THEN col.max_length ELSE col.precision END AS size
		,SCHEMA_NAME(obj.schema_id) AS SCHEMA_NAME
		,OBJECT_NAME(col.object_id) AS OBJECT_NAME
		,obj.type
	FROM sys.columns AS col
	JOIN sys.objects AS obj
	ON col.object_id = obj.object_id
	JOIN sys.types AS typ
	ON col.system_type_id = typ.system_type_id
	WHERE SCHEMA_NAME(obj.schema_id) != 'sys'
	AND obj.name LIKE @pObjectName
	ORDER BY obj.name, col.column_id
);
GO


SELECT *
FROM dbo.ufnGetColumns('AD');