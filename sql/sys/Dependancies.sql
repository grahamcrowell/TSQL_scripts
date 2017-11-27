USE CommunityMart
GO

SELECT *
FROM sys.sql_expression_dependencies

SELECT *
FROM sys.sql_dependencies

SELECT 
	OBJECT_NAME(referencing_id) AS referencing_entity_name,   
    o.type_desc AS referencing_desciption,   
    COALESCE(COL_NAME(referencing_id, referencing_minor_id), '(n/a)') AS referencing_minor_id,   
    referencing_class_desc,  
    referenced_server_name, referenced_database_name, referenced_schema_name,  
    referenced_entity_name,   
    COALESCE(COL_NAME(referenced_id, referenced_minor_id), '(n/a)') AS referenced_column_name,  
    is_caller_dependent, is_ambiguous  
FROM sys.sql_expression_dependencies AS sed  
LEFT JOIN sys.objects AS o ON sed.referencing_id = o.object_id  
--WHERE referencing_id = OBJECT_ID(N'dbo.ReferralFact');  
GO  