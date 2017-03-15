USE DSDW
GO

-- tables
SELECT
	DB_NAME(DB_ID()) AS [database_name]
	,sch.name AS [schema_name]
	,tab.name AS [table_name]
	,tab.object_id
FROM sys.schemas AS sch
JOIN sys.tables AS tab
ON tab.schema_id = sch.schema_id

-- table columns
SELECT TOP 10000
	DB_NAME(DB_ID()) AS [database_name]
	,sch.name AS [schema_name]
	,tab.name AS [table_name]
	,tab.object_id
	,col.name AS [column_name]
	,col.column_id
	,typ.name AS [type_name]
	,col.max_length
	,col.precision
	,col.scale
	,col.is_ansi_padded
	,col.is_nullable
	,col.is_identity
FROM sys.schemas AS sch
JOIN sys.tables AS tab
ON tab.schema_id = sch.schema_id
JOIN sys.columns AS col
ON tab.object_id = col.object_id
JOIN sys.types AS typ
ON col.user_type_id = typ.user_type_id

-- indexes

