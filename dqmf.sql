
USE DQMF
GO

DECLARE @stage_name varchar(100);
DECLARE @db_name varchar(100);
DECLARE @brid int;

SET @brid = 0
SET @db_name =  ' '
SET @stage_name =   'CCRSLoadtoDSDW 5 AD-Admission Prior to setPatient'


SELECT 
	br.BRId
	,br.ShortNameOfTest
	,br.ActionID
	,sch.DQMF_ScheduleId
	,br.Sequence
	,stg.StageName
	,etl.PkgName
	,db.DatabaseName
	,TargetObjectPhysicalName
	,TargetObjectAttributePhysicalName
	,CASE WHEN br.ActionSQL = '' THEN br.ConditionSQL ELSE br.ActionSQL END AS SQL_Code
	,CASE WHEN br.ActionSQL = '' THEN 'ConditionSQL' ELSE 'ActionSQL' END AS SQL_Code_Use
	,br.*
FROM DQMF_BizRule AS br
JOIN DQMF_BizRuleSchedule AS br_sch
ON br.BRID = br_sch.BRID
JOIN DQMF_Schedule AS sch
ON sch.DQMF_ScheduleId = br_sch.ScheduleID
JOIN DQMF_Stage AS stg
ON stg.StageID = sch.StageID
JOIN ETL_Package AS etl
ON sch.PkgKey = etl.PkgID
JOIN MD_Database AS db
ON sch.DatabaseId = db.DatabaseId
WHERE stg.StageName LIKE @stage_name
OR br.BRId = @brid
OR db.DatabaseName LIKE @db_name
ORDER BY br.Sequence ASC

DECLARE @md_db varchar(100);
DECLARE @md_sub varchar(100);
DECLARE @md_obj varchar(100);
DECLARE @md_pk varchar(100);
DECLARE @md_tab varchar(100);
DECLARE @md_col varchar(100);
DECLARE @md_type varchar(100);
DECLARE @md_pur varchar(100);

SELECT 
	''
	,sub.SubjectAreaName
	,db.DatabaseName
	,obj.ObjectPhysicalName
	,obj_attr.AttributePhysicalName
	,obj.ObjectType
	,obj.ObjectPKField
	,obj.ObjectPurpose
	,obj.ObjectDisplayName
	,attr.AttributeDisplayName
FROM MD_Object AS obj
JOIN MD_Database AS db
ON obj.DatabaseId = db.DatabaseId
JOIN MD_SubjectArea AS sub
ON db.DatabaseId = sub.DatabaseID
AND obj.SubjectAreaID = sub.SubjectAreaID
JOIN MD_ObjectAttribute AS obj_attr
ON obj.ObjectID = obj_attr.ObjectID
JOIN MD_Attribute AS attr
ON obj_attr.AttributeID = attr.AttributeID
WHERE sub.SubjectAreaName LIKE @md_sub
OR db.DatabaseName LIKE @db_name
OR obj.ObjectPhysicalName LIKE @md_tab
OR obj_attr.AttributePhysicalName LIKE @md_col
OR obj.ObjectType LIKE @md_type
OR obj.ObjectPurpose LIKE @md_pur
OR obj.ObjectPKField LIKE @md_pk
