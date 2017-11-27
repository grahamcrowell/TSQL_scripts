

;WITH mart AS (
	-- get all constraints in destination table
	SELECT DISTINCT
		tab.object_id
		,tab.name AS table_name
		,idx.name AS index_name
		,col.name AS column_name
		,idx.is_primary_key
		,idx.is_unique
		,idx.is_unique_constraint
		,idx_col.key_ordinal
	FROM CommunityMart.sys.schemas AS sch
	JOIN CommunityMart.sys.tables AS tab
	ON sch.schema_id = tab.schema_id
	JOIN CommunityMart.sys.columns AS col
	ON col.object_id = tab.object_id
	JOIN CommunityMart.sys.indexes AS idx
	ON tab.object_id = idx.object_id
	JOIN CommunityMart.sys.index_columns AS idx_col
	ON idx.index_id = idx_col.index_id
	AND idx.object_id = idx_col.object_id
	AND idx_col.column_id = col.column_id
	WHERE sch.name = 'dbo'
), dsdw AS (
	SELECT DISTINCT
		-- get all constraints in source table
		tab.object_id
		,tab.name AS table_name
		,idx.name AS index_name
		,col.name AS column_name
		,idx.is_primary_key
		,idx.is_unique
		,idx.is_unique_constraint
		,idx_col.key_ordinal
	FROM DSDW.sys.schemas AS sch
	JOIN DSDW.sys.tables AS tab
	ON sch.schema_id = tab.schema_id
	JOIN DSDW.sys.columns AS col
	ON col.object_id = tab.object_id
	JOIN DSDW.sys.indexes AS idx
	ON tab.object_id = idx.object_id
	JOIN DSDW.sys.index_columns AS idx_col
	ON idx.index_id = idx_col.index_id
	AND idx.object_id = idx_col.object_id
	AND idx_col.column_id = col.column_id
	WHERE sch.name = 'Community'
), mis AS (
	-- get all instances where a unique index/constraint exists in source but destination (and vice versa)
	SELECT 
		dsdw.object_id AS dsdw_object_id
		,dsdw.table_name AS dsdw_table_name
		,dsdw.index_name AS dsdw_index_name
		,dsdw.column_name AS dsdw_column_name
		,dsdw.is_primary_key AS dsdw_is_primary_key
		,dsdw.is_unique AS dsdw_is_unique
		,dsdw.is_unique_constraint AS dsdw_is_unique_constraint
		,dsdw.key_ordinal AS dsdw_key_ordinal

		,mart.object_id AS mart_object_id
		,mart.table_name AS mart_table_name
		,mart.index_name AS mart_index_name
		,mart.column_name AS mart_column_name
		,mart.is_primary_key AS mart_is_primary_key
		,mart.is_unique AS mart_is_unique
		,mart.is_unique_constraint AS mart_is_unique_constraint
		,mart.key_ordinal AS mart_key_ordinal
	FROM dsdw
	FULL JOIN mart
	ON dsdw.table_name = mart.table_name
	AND dsdw.column_name = mart.column_name
	AND dsdw.is_unique = mart.is_unique
	AND dsdw.key_ordinal = mart.key_ordinal
	WHERE (dsdw.is_unique = 1
	OR mart.is_unique = 1)
	AND (dsdw.table_name IS NULL
	OR mart.table_name IS NULL)
)
SELECT DISTINCT 
	-- filter to all instances where a unique constraint exists in dest but not in source
	-- !!! potiential for run-time ETL errors !!!
	mart_table_name
	,mart_index_name
	,mart_column_name
	,mart_key_ordinal
FROM mis
WHERE mis.dsdw_table_name IS NULL
ORDER BY
	mart_table_name ASC
	,mart_index_name ASC
	,mart_key_ordinal ASC