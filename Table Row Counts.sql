USE DQMF
GO

drop table  #row_counts;

create table  #row_counts (
	schema_name varchar(100)
	,table_name varchar(100)
	,row_count int
);
exec sp_MSforeachtable '

--IF ''?'' = ''[dbo].[DQMF_OlsonType]''
BEGIN
DECLARE @schema_name varchar(100) = PARSENAME(''?'',2)
DECLARE @table_name varchar(100) = PARSENAME(''?'',1)
DECLARE @row_count int;

IF @schema_name != ''DataProfile''
BEGIN

SELECT @row_count= COUNT(*) FROM ?;

INSERT INTO #row_counts VALUES (@schema_name, @table_name, @row_count);
END
END
'
SELECT * FROM #row_counts;