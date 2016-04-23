


USE DSDW
GO

SELECT 
	DB_NAME() AS database_name
	,sch.name AS schema_name
	,tab.object_id
	,tab.name AS table_name
	,col.column_id
	,col.name AS column_name
	,col.is_nullable
	,col.is_identity
	,typ.name AS column_type
	,idx_col.index_column_id
	,idx.name AS index_name
	,idx.type_desc AS index_type
	,idx_col.key_ordinal
FROM sys.schemas AS sch
JOIN sys.tables AS tab
ON sch.schema_id = tab.schema_id
JOIN sys.columns AS col
ON tab.object_id = col.object_id
JOIN sys.types AS typ
ON col.system_type_id = typ.system_type_id
LEFT OUTER JOIN sys.index_columns AS idx_col
ON col.object_id = idx_col.object_id
AND col.column_id = idx_col.column_id
LEFT OUTER JOIN sys.indexes AS idx
ON idx.object_id = col.object_id
AND idx_col.index_id = idx.index_id
ORDER BY sch.name, tab.name, col.column_id

