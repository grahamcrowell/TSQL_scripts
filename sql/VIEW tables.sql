USE CommunityMart
GO

-- 

DECLARE @viewName varchar(500)-- = 'vwPARISIntervention'

SELECT OBJECT_NAME(referencing_id) AS viewName,   
    vw.type_desc AS referencing_desciption,   
    --COALESCE(COL_NAME(referencing_id, referencing_minor_id), '(n/a)') AS referencing_minor_id,   
    --referencing_class_desc, referenced_class_desc,  
    --referenced_server_name, referenced_database_name, 
	referenced_schema_name,  
    referenced_entity_name
    --COALESCE(COL_NAME(referenced_id, referenced_minor_id), '(n/a)') AS referenced_column_name,  
    --is_caller_dependent, is_ambiguous  
	--,col.name AS column_name
	--,ROW_NUMBER() OVER(PARTITION BY OBJECT_NAME(referencing_id), col.name ORDER BY col.name)
	--,LAG(1) OVER(PARTITION BY OBJECT_NAME(referencing_id) ORDER BY col.name)
FROM sys.sql_expression_dependencies AS sed  
INNER JOIN sys.objects AS vw
ON sed.referencing_id = vw.object_id  
--JOIN sys.columns AS col
--ON OBJECT_NAME(col.object_id) = referenced_entity_name
WHERE 1=1
AND OBJECT_NAME(referencing_id) = isnull(@viewName,OBJECT_NAME(referencing_id))
--AND o.type_desc = 'VIEW'
--WHERE referencing_id = OBJECT_ID(@viewName);  
--ORDER BY col.name