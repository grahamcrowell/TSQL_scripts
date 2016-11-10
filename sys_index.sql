USE CommunityMart
GO

SELECT 
	sch.name AS schema_name
	,tab.name AS table_name
	,ix.name AS index_name
	,ix.type_desc AS index_type
	,ix.is_unique
	,ix.is_unique_constraint
	,ix.is_primary_key
	,col.name AS column_name
	,col.is_nullable
	,ix_col.index_column_id
FROM sys.schemas AS sch
JOIN sys.tables AS tab
ON sch.schema_id = tab.schema_id
JOIN sys.indexes AS ix
ON tab.object_id = ix.object_id
JOIN sys.index_columns AS ix_col
ON ix.object_id = ix_col.object_id
AND ix.index_id = ix_col.index_id
JOIN sys.columns AS col
ON ix_col.column_id = col.column_id
AND tab.object_id = col.object_id
WHERE 1=1
AND tab.type_desc = 'USER_TABLE'
AND col.name = 'ETLAuditID'
AND ix.type_desc = 'CLUSTERED'
AND tab.name NOT IN ('YouthClinicTestResultFact')
ORDER BY sch.name, tab.name, ix.type_desc, ix_col.index_column_id

