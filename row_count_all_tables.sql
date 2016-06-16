CREATE TABLE #table_count (
	table_name varchar(100)
	,row_count int
);
GO
sp_MSforeachtable @command1="INSERT INTO #table_count select '?' AS TABLE_NAME,count(*) AS row_count from ?"


SELECT *
FROM #table_count;

DROP TABLE #table_name;