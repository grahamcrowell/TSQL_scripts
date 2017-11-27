USE AutoTest
GO

DECLARE @table_name varchar(500);
SET @table_name = 'OCCUPATIONS';
SET @table_name = 'column_profile';
DECLARE @sql varchar(MAX);
DECLARE @insert varchar(MAX);
;WITH meta AS (
SELECT
    ROW_NUMBER() OVER(PARTITION BY col.object_id ORDER BY col.column_id) AS col_rn
    ,LAG(tab.name) OVER(ORDER BY tab.name) AS prev_table_name
    ,LEAD(tab.name) OVER(ORDER BY tab.name) AS next_table_name
    ,tab.name AS table_name
    -- ,col.name
    ,col.name AS column_name
    ,CASE 
        WHEN typ.name LIKE '%char%' OR typ.name LIKE '%bin%'
            THEN typ.name+'('+
            CASE WHEN col.max_length = -1 THEN 'MAX' ELSE            CAST(col.max_length AS varchar) END+')'
        WHEN typ.name IN ('numeric', 'decimal')
            THEN typ.name+'('+CAST(col.[precision] AS varchar)+', '+CAST(col.scale AS varchar)+')'
        ELSE typ.name 
    END AS type_desc
    ,col.column_id
FROM sys.tables AS tab
JOIN sys.columns AS col
ON tab.object_id = col.object_id
JOIN sys.types AS typ
ON col.user_type_id = typ.user_type_id
), fmt AS (
SELECT 
    CASE WHEN prev_table_name IS NULL AND col_rn = 1 THEN 'CREATE TABLE '+table_name+'('+CHAR(13)+CHAR(10)+column_name + ' '+type_desc
    WHEN col_rn = 1 THEN '); '+CHAR(13)+CHAR(10)+'CREATE TABLE '+table_name+'('+CHAR(13)+CHAR(10)+CHAR(9)+column_name + ' '+type_desc
    WHEN next_table_name IS NULL THEN ','+column_name + ' '+type_desc+');'
    ELSE CHAR(9)+','+column_name + ' '+type_desc
    END AS create_stmt
FROM meta
)
SELECT @sql = COALESCE(@sql + CHAR(13)+CHAR(10), '')+ create_stmt
FROM fmt



SELECT @sql

-- SELECT 'INSERT INTO '+@table_name +' VALUES('''++''','''++''','''++''');'
SELECT 'INSERT INTO '+@table_name +' VALUES('''+Name+''','''+Occupation+''');'
FROM OCCUPATIONS



