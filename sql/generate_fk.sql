
USE gcCCRSMart
GO


DROP TABLE sys;

SELECT 
	sch.name AS schema_name
	,tab.object_id AS object_id
	,tab.name AS table_name
	,col.column_id AS column_id
	,col.name AS column_name
	,typ.name AS type_name
INTO sys
FROM sys.schemas AS sch
JOIN sys.tables AS tab
ON sch.schema_id = tab.schema_id
JOIN sys.columns AS col
ON tab.object_id = col.object_id
JOIN sys.types AS typ
ON col.system_type_id = typ.system_type_id
WHERE tab.name != 'sys'
AND sch.name != 'Dim';



--DECLARE cur cursor
--FOR 
WITH cols AS (
SELECT column_name, count(*) AS cnt
FROM sys
GROUP BY column_name
HAVING COUNT(*) > 1),
tabs AS (
	SELECT *
	FROM sys
)
SELECT cnt, tabs.*
FROM cols
JOIN tabs
ON cols.column_name = tabs.column_name
ORDER BY cnt DESC;

--DECLARE @column_id int
--DECLARE @object_id int 
--DECLARE @schema_name varchar(100)
--DECLARE @table_name varchar(100)
--DECLARE @column_name varchar(100)
--DECLARE @type_name varchar(100)


--OPEN cur;

--CLOSE cur;
--DEALLOCATE cur;