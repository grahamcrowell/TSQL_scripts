USE [AdventureWorks]
GO

SET NOCOUNT ON;
GO

----Create a sample table to simulate a table with TSQL Commands
--drop table dbo.TSQL_Commands
CREATE TABLE dbo.TSQL_Commands(Id INT,ObjName VARCHAR(100), tsql_stmt NVARCHAR(MAX));
INSERT INTO dbo.TSQL_Commands VALUES (1,NULL,'SELECT *
FROM person.contact c
INNER JOIN person.[Address] ON [c].[rowguid] = [Address].[rowguid]
WHERE [ContactID] < 50');
INSERT INTO dbo.TSQL_Commands VALUES (2,NULL,'SELECT *
FROM person.contact c
INNER JOIN person.[Address] ON [c].[rowguid] = [Address].[rowguid]');
INSERT INTO dbo.TSQL_Commands VALUES (3,NULL,'SELECT *
FROM [Sales].[SalesOrderHeader] sh
INNER JOIN sales.[SalesOrderDetail] sd ON [sh].[SalesOrderID] = [sd].[SalesOrderID]
INNER JOIN sales.[SalesOrderHeaderSalesReason] ON [sd].[SalesOrderID] = [SalesOrderHeaderSalesReason].[SalesOrderID]')
INSERT INTO dbo.TSQL_Commands VALUES (4,'dbo.uspGetEmployeeManagers','EXECUTE [dbo].[uspGetEmployeeManagers] @EmployeeID=50');
INSERT INTO dbo.TSQL_Commands VALUES (5,'[dbo].[uspGetBillOfMaterials]','EXECUTE [dbo].[uspGetBillOfMaterials] @StartProductID=500,@CheckDate=''20090203''')
INSERT INTO dbo.TSQL_Commands VALUES (6,'dbo.vw_test','select * from vw_test')
GO

--Cursor to execute dynamic sql with fmtonly, so the stmt is not actually executed, but a query plan is built
DECLARE @sql NVARCHAR(MAX)

DECLARE curExecDynSQL CURSOR LOCAL STATIC FOR
SELECT tsql_stmt
FROM dbo.TSQL_Commands

OPEN curExecDynSQL
FETCH NEXT FROM curExecDynSQL INTO @sql

WHILE @@FETCH_STATUS = 0
  BEGIN
		--PRINT @sql
		SET FMTONLY ON;
		EXEC sp_executesql @sql
		SET FMTONLY OFF;
		
		FETCH NEXT FROM curExecDynSQL INTO @sql
  END

CLOSE curExecDynSQL
DEALLOCATE curExecDynSQL
GO

--Cache query to extract tables names from the cached execution plan
;WITH XMLNAMESPACES (DEFAULT 'http://schemas.microsoft.com/sqlserver/2004/07/showplan')
SELECT 
	[id],
	(SELECT [processing-instruction(x)]=[Stmt] FOR XML PATH(''),TYPE) AS [Stmt],
	[db],
	[Schema],
	[Tbl],
	[Alias]
FROM(
SELECT
	tsql_st.id,
	SUBSTRING(
		st.text,
		(qs.statement_start_offset/2)+1, 
		(
		 (
		 CASE qs.statement_end_offset
			WHEN -1 THEN DATALENGTH(st.text)
		 ELSE qs.statement_end_offset
		 END - qs.statement_start_offset)/2
		 ) 
		 + 1) AS Stmt,
	x.i.value('(OutputList/ColumnReference/@Database)[1]', 'VARCHAR(100)')AS [db],
	x.i.value('(OutputList/ColumnReference/@Schema)[1]', 'VARCHAR(100)')AS [Schema],
	x.i.value('(OutputList/ColumnReference/@Table)[1]', 'VARCHAR(100)')AS [Tbl],
	x.i.value('(OutputList/ColumnReference/@Alias)[1]', 'VARCHAR(100)')AS [Alias]
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text([sql_handle]) st
CROSS APPLY sys.dm_exec_query_plan([plan_handle]) qp
CROSS APPLY qp.query_plan.nodes('//RelOp') x(i)
INNER JOIN dbo.TSQL_Commands tsql_st 
	ON tsql_st.[tsql_stmt] COLLATE SQL_Latin1_General_CP1_CI_AS = 
			SUBSTRING(st.text,(qs.statement_start_offset/2)+1,((
					 CASE qs.statement_end_offset
						WHEN -1 THEN DATALENGTH(st.text)
					 ELSE qs.statement_end_offset
					 END - qs.statement_start_offset)/2)+ 1) 
			OR st.[objectid] = object_id(tsql_st.ObjName)
WHERE 
	x.i.value('@PhysicalOp', 'NVARCHAR(200)') IN('Table Scan','Index Scan','Clustered Index Scan','Index Seek','Clustered Index Seek')
	AND EXISTS(
		SELECT 1
		FROM sys.tables t
		WHERE 
			t.name = REPLACE(REPLACE(x.i.value('(OutputList/ColumnReference/@Table)[1]', 'VARCHAR(100)'),'[',''),']','')
			AND T.TYPE = 'U'
			AND T.is_ms_shipped = 0
		)
) AS x
GROUP BY 
	[id],
	[db],
	[Schema],
	[Tbl],
	[Alias],
	[Stmt]
ORDER BY [id] ASC