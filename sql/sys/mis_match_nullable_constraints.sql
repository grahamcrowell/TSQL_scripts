

;WITH mart AS (
	-- get all constraints in destination table
	SELECT DISTINCT
		tab.object_id
		,tab.name AS table_name
		,col.name AS column_name
		,col.is_nullable
	FROM CommunityMart.sys.schemas AS sch
	JOIN CommunityMart.sys.tables AS tab
	ON sch.schema_id = tab.schema_id
	JOIN CommunityMart.sys.columns AS col
	ON col.object_id = tab.object_id
	WHERE sch.name = 'dbo'
), dsdw AS (
	-- get all constraints in source table
	SELECT DISTINCT
		tab.object_id
		,tab.name AS table_name
		,col.name AS column_name
		,col.is_nullable
	FROM DSDW.sys.schemas AS sch
	JOIN DSDW.sys.tables AS tab
	ON sch.schema_id = tab.schema_id
	JOIN DSDW.sys.columns AS col
	ON col.object_id = tab.object_id
	WHERE sch.name = 'Community'
), mis AS (
	-- get all instances where a unique index/constraint exists in source but destination (and vice versa)
	SELECT 
		dsdw.object_id AS dsdw_object_id
		,dsdw.table_name AS dsdw_table_name
		,dsdw.column_name AS dsdw_column_name

		,mart.object_id AS mart_object_id
		,mart.table_name AS mart_table_name
		,mart.column_name AS mart_column_name
	FROM dsdw
	FULL JOIN mart
	ON dsdw.table_name = mart.table_name
	AND dsdw.column_name = mart.column_name
	AND dsdw.is_nullable = mart.is_nullable
	WHERE (dsdw.is_nullable = 0
	OR mart.is_nullable = 0)
)
SELECT DISTINCT 
	-- filter to all instances where a unique constraint exists in dest but not in source
	-- !!! potiential for run-time ETL errors !!!
	mart_table_name
	,mart_column_name
FROM mis
WHERE mis.dsdw_table_name IS NULL
ORDER BY
	mart_table_name ASC
	,mart_column_name ASC
