USE DQMF
GO

SELECT COUNT(*) AS [testableTableCount (248)]
FROM MD_Object AS fact
WHERE 1=1
AND fact.IsActive=1
AND fact.IsObjectInDB = 1
AND fact.ObjectSchemaName NOT IN ('Staging','Dim')
AND fact.ObjectType LIKE 'Table'
AND fact.DatabaseId = 2


SELECT COUNT(*) AS [stageTableCount (510)]
FROM MD_Object AS fact
WHERE 1=1
AND fact.IsActive=1
AND fact.IsObjectInDB = 1
AND fact.ObjectSchemaName LIKE 'Staging'
AND fact.ObjectType LIKE 'Table'
AND fact.DatabaseId = 2



;with stg_fact AS (
SELECT sub2.*
FROM (
SELECT sub.*
	,ROW_NUMBER() OVER(PARTITION BY factTableName ORDER BY commonColCount DESC) as commonColRank
	,1.0*commonColCount/(MAX(commonColCount) OVER(PARTITION BY factTableName ORDER BY commonColCount DESC)) as commonColPercent
	--,ISNULL(1.*sub.commonColCount/(LAG(sub.commonColCount) OVER(PARTITION BY factTableName ORDER BY sub.commonColCount DESC)),1.0)  as maxCommonColCountIndicator
FROM (
SELECT 
	fact.ObjectPhysicalName AS factTableName
	,fact.ObjectSchemaName +'.'+fact.ObjectPhysicalName AS factFullName
	,stg.ObjectPhysicalName AS stgTableName
	,ROW_NUMBER() OVER(PARTITION BY fact.ObjectPhysicalName, stg.ObjectPhysicalName ORDER BY fact_attr.AttributePhysicalName) as commonColCount
	,LEAD(stg.ObjectPhysicalName) OVER(PARTITION BY fact.ObjectPhysicalName, stg.ObjectPhysicalName ORDER BY fact_attr.AttributePhysicalName) as maxCommonColCountIndicator
	,stg.ObjectSchemaName +'.'+stg.ObjectPhysicalName AS stgFullName
	,stg.ObjectID AS stgObjectID
	,fact.ObjectID AS factObjectID
FROM MD_Object fact
JOIN MD_ObjectAttribute AS fact_attr
ON fact.objectid = fact_attr.objectid
CROSS JOIN MD_Object AS stg
JOIN MD_ObjectAttribute AS stg_attr
ON stg.objectid = stg_attr.objectid
AND stg_attr.AttributePhysicalName = fact_attr.AttributePhysicalName
WHERE 1=1
AND fact.IsActive=1
AND fact.IsObjectInDB = 1
AND fact.ObjectSchemaName NOT IN ('Staging','Dim')
AND fact.ObjectType LIKE 'Table'
AND fact.DatabaseId = 2
AND stg.IsActive=1
AND stg.IsObjectInDB = 1
AND stg.ObjectSchemaName LIKE 'Staging'
AND stg.DatabaseId = 2
) sub
WHERE 1=1
AND sub.maxCommonColCountIndicator IS NULL
) sub2
WHERE sub2.commonColRank = 1)


SELECT
	DISTINCT
	--MAX(ISNULL(pkg.PkgName,0)) AS pkg,
	pkg.PkgName
	,obj.ObjectID
	--stg_fact.stgFullName
	--,stg_fact.factFullName
FROM ETL_Package AS pkg
JOIN DQMF_Schedule AS sch
ON pkg.PkgID = sch.PkgKey
JOIN DQMF_BizRuleSchedule AS br_sch
ON sch.DQMF_ScheduleId = br_sch.ScheduleID
JOIN DQMF_BizRule AS br
ON br.BRId = br_sch.BRID
LEFT JOIN MD_ObjectAttribute AS attr
ON br.FactTableObjectAttributeId = attr.ObjectAttributeID
LEFT JOIN MD_Object AS obj
ON obj.ObjectID = attr.ObjectID
LEFT JOIN MD_SubjectArea AS sub
ON obj.SubjectAreaID = sub.SubjectAreaID
FULL JOIN stg_fact
ON br.TargetObjectPhysicalName = stg_fact.stgFullName
WHERE pkg.IsACtive=1
--WHERE stg_fact.stgFullName IS NULL
--GROUP BY 	ISNULL(stg_fact.stgFullName, obj.ObjectSchemaName +'.'+obj.ObjectPhysicalName)
	--,stg_fact.factTableName
--OR br.FactTableObjectAttributeId = stg_fact.
--ORDER BY MAX(ISNULL(pkg.PkgName,0))
--WHERE stg_fact.factTableName NOT IN (


--SELECT fact.ObjectPhysicalName
--FROM MD_Object fact 
--JOIN MD_ObjectAttribute AS fact_attr
--ON fact.objectid = fact_attr.objectid
--where fact.IsActive=1
--AND fact.ObjectSchemaName NOT IN ('Staging','Dim')
--AND fact.ObjectType LIKE 'Table'
--AND fact.DatabaseId = 2
--AND pkg_fact.factTableName IS NULL
--)


--SELECT *
--FROM ETL_Package AS pkg
--JOIN DQMF_Schedule AS sch
--ON pkg.PkgID = sch.PkgKey
--JOIN DQMF_BizRuleSchedule AS br_sch
--ON sch.DQMF_ScheduleId = br_sch.ScheduleID
--JOIN DQMF_BizRule AS br
--ON br_sch.BRID = br.BRId
--JOIN DQMF_BizRuleLookupMapping AS br_lkup
--ON br.BRId = br_lkup.BRId

--SELECT 
--	obj.ObjectPhysicalName
--	,obj.*
--FROM MD_Object AS obj
--WHERE 1=1
--AND obj.IsActive=1
--AND obj.ObjectSchemaName = 'Dim'
--AND obj.ObjectType LIKE 'Table'
--AND obj.DatabaseId = 2
--AND obj.ObjectPhysicalName NOT IN(

--;WITH pkg_dim AS (
--SELECT
--	DISTINCT
--	pkg.PkgName,
--	dim.ObjectPhysicalName AS dimTableName
--FROM ETL_Package AS pkg
--JOIN DQMF_Schedule AS sch
--ON pkg.PkgID = sch.PkgKey
--JOIN DQMF_BizRuleSchedule AS br_sch
--ON sch.DQMF_ScheduleId = br_sch.ScheduleID
--JOIN DQMF_BizRule AS br
--ON br.BRId = br_sch.BRID
--JOIN DQMF_BizRuleLookupMapping AS br_lkup
--ON br.BRId = br_lkup.BRId
--AND br_lkup.JoinNumber = 1
--JOIN MD_Object AS dim
--ON br.SourceObjectPhysicalName = dim.ObjectSchemaName +'.'+dim.ObjectPhysicalName
--JOIN MD_ObjectAttribute AS dim_attr
--ON dim.objectid = dim_attr.objectid
--AND br.SourceAttributePhysicalName = dim_attr.AttributePhysicalName
--AND br.IsActive=1
--AND dim.IsActive=1
--AND dim.ObjectSchemaName = 'Dim'
--), fact_dim AS (
--SELECT 
--	--fact.ObjectSchemaName,
--	fact.ObjectPhysicalName AS factTableName
--	--,fact_attr.AttributePhysicalName
--	,dim.ObjectPhysicalName AS dimTableName
--	--,ROW_NUMBER() OVER(PARTITION BY fact.ObjectPhysicalName ORDER BY dim.ObjectPhysicalName) as rn
--	--,fact.*
--FROM MD_Object fact
--JOIN MD_ObjectAttribute AS fact_attr
--ON fact.objectid = fact_attr.objectid
--CROSS JOIN MD_Object AS dim
--JOIN MD_ObjectAttribute AS dim_attr
--ON dim.objectid = dim_attr.objectid
--AND dim_attr.AttributePhysicalName = fact_attr.AttributePhysicalName
--WHERE 1=1
--AND fact.IsActive=1
--AND fact.ObjectSchemaName NOT IN ('Staging','Dim')
--AND fact.ObjectType LIKE 'Table'
--AND fact.DatabaseId = 2
--AND dim.IsActive=1
--AND dim.ObjectSchemaName LIKE 'Dim'
--AND dim.DatabaseId = 2
--)
----, pkg_fact AS (
----SELECT 
----	obj.ObjectPhysicalName
----	,obj.*
----FROM MD_Object AS obj
----WHERE 1=1
----AND obj.IsActive=1
----AND obj.ObjectSchemaName = 'Dim'
----AND obj.ObjectType LIKE 'Table'
----AND obj.ObjectPurpose LIKE 'Fact'
----AND obj.DatabaseId = 2
----AND obj.ObjectPhysicalName NOT IN (
----SELECT factTableName
--SELECT pkg_dim.PkgName
--	,fact_dim.*
--	,ROW_NUMBER() OVER(PARTITION BY fact_dim.factTableName ORDER BY pkg_dim.PkgName, fact_dim.factTableName) as rn
--FROM pkg_dim
--JOIN fact_dim ON
--pkg_dim.dimTableName = fact_dim.dimTableName
--ORDER BY pkg_dim.PkgName, fact_dim.factTableName
----)
----SELECT
----	DISTINCT
----	pkg_fact.PkgName
----	,pkg_fact.factTableName
----FROM pkg_fact
----ORDER BY pkg_fact.factTableName, pkg_fact.PkgName





--;WITH pkg_stg_dim AS ( 
--SELECT 
--	DISTINCT
--	pkg.PkgName
--	,stg.ObjectPhysicalName AS targetTableName
--	,dim.ObjectPhysicalName AS sourceTableName
--	--,dim_attr.AttributePhysicalName AS sourceColumnName
--	,ROW_NUMBER() OVER(PARTITION BY dim.ObjectPhysicalName ORDER BY stg.ObjectPhysicalName) AS rn
--FROM MD_Object AS stg
--JOIN MD_ObjectAttribute AS stg_attr
--ON stg.ObjectID = stg_attr.ObjectID
--JOIN DQMF_BizRule AS br
--ON br.TargetObjectPhysicalName = stg.ObjectPhysicalName
--OR br.TargetObjectPhysicalName = stg.ObjectSchemaName +'.'+stg.ObjectPhysicalName
--	JOIN DQMF_BizRuleSchedule AS br_sch
--	ON br.BRId = br_sch.BRId
--	JOIN DQMF_Schedule AS sch
--	ON br_sch.ScheduleID = sch.DQMF_ScheduleId
--	JOIN ETL_Package AS pkg
--	ON pkg.PkgID = sch.PkgKey
--JOIN MD_Object AS dim
--ON br.SourceObjectPhysicalName = dim.ObjectSchemaName +'.'+dim.ObjectPhysicalName

----JOIN MD_ObjectAttribute AS dim_attr
----ON dim.ObjectID = dim_attr.ObjectID
----AND dim_attr.AttributePhysicalName = stg_attr.AttributePhysicalName
--WHERE 1=1
--AND stg.ObjectSchemaName = 'Staging'
--AND stg.IsActive = 1
--AND stg.DatabaseId = 2
--AND br.IsActive=1
--AND br.ActionID = 0
--AND dim.ObjectSchemaName = 'Dim'
--AND dim.IsActive = 1
--AND dim.DatabaseId = 2
--), fact_dim AS (
--SELECT 
--	--fact.ObjectSchemaName,
--	fact.ObjectPhysicalName AS factTableName
--	--,fact_attr.AttributePhysicalName
--	,dim.ObjectPhysicalName AS dimTableName
--	--,ROW_NUMBER() OVER(PARTITION BY fact.ObjectPhysicalName ORDER BY dim.ObjectPhysicalName) as rn
--	--,fact.*
--FROM MD_Object fact
--JOIN MD_ObjectAttribute AS fact_attr
--ON fact.objectid = fact_attr.objectid
--CROSS JOIN MD_Object AS dim
--JOIN MD_ObjectAttribute AS dim_attr
--ON dim.objectid = dim_attr.objectid
--AND dim_attr.AttributePhysicalName = fact_attr.AttributePhysicalName
--WHERE 1=1
--AND fact.IsActive=1
--AND fact.ObjectSchemaName NOT IN ('Staging','Dim')
--AND fact.ObjectType LIKE 'Table'
--AND fact.DatabaseId = 2
--AND dim.IsActive=1
--AND dim.ObjectSchemaName LIKE 'Dim'
--AND dim.DatabaseId = 2
--)
--SELECT 
--	factTableName, PkgName, COUNT(*)
--FROM fact_dim
--JOIN pkg_stg_dim
--ON fact_dim.dimTableName = pkg_stg_dim.sourceTableName
--GROUP BY factTableName, PkgName
--ORDER BY factTableName, COUNT(*), PkgName








--;with pkg_fact AS (
--SELECT sub2.*
--FROM (
--SELECT sub.*
--	,ROW_NUMBER() OVER(PARTITION BY factTableName ORDER BY commonColCount DESC) as commonColRank
--	,1.0*commonColCount/(MAX(commonColCount) OVER(PARTITION BY factTableName ORDER BY commonColCount DESC)) as commonColPercent
--	--,ISNULL(1.*sub.commonColCount/(LAG(sub.commonColCount) OVER(PARTITION BY factTableName ORDER BY sub.commonColCount DESC)),1.0)  as maxCommonColCountIndicator
--FROM (
--SELECT 
--	fact.ObjectSchemaName,
--	fact.ObjectPhysicalName AS factTableName
--	--,fact_attr.AttributePhysicalName
--	,stg.ObjectPhysicalName AS stgTableName
--	,ROW_NUMBER() OVER(PARTITION BY fact.ObjectPhysicalName, stg.ObjectPhysicalName ORDER BY fact_attr.AttributePhysicalName) as commonColCount
--	,LEAD(stg.ObjectPhysicalName) OVER(PARTITION BY fact.ObjectPhysicalName, stg.ObjectPhysicalName ORDER BY fact_attr.AttributePhysicalName) as maxCommonColCountIndicator
--	--,fact.*
--FROM MD_Object fact
--JOIN MD_ObjectAttribute AS fact_attr
--ON fact.objectid = fact_attr.objectid
--CROSS JOIN MD_Object AS stg
--JOIN MD_ObjectAttribute AS stg_attr
--ON stg.objectid = stg_attr.objectid
--AND stg_attr.AttributePhysicalName = fact_attr.AttributePhysicalName
--WHERE 1=1
--AND fact.IsActive=1
--AND fact.ObjectSchemaName NOT IN ('Staging','Dim')
--AND fact.ObjectType LIKE 'Table'
--AND fact.DatabaseId = 2
--AND stg.IsActive=1
--AND stg.ObjectSchemaName LIKE 'Staging'
--AND stg.DatabaseId = 2
----AND fact.ObjectSchemaName = 'Community'
--) sub
--WHERE 1=1
--AND sub.maxCommonColCountIndicator IS NULL
--) sub2
--WHERE sub2.commonColRank = 1)

--SELECT *
--FROM MD_Object fact 
--LEFT JOIN pkg_fact
--ON pkg_fact.factTableName = ObjectPhysicalName
--where fact.IsActive=1
--AND fact.ObjectSchemaName NOT IN ('Staging','Dim')
--AND fact.ObjectType LIKE 'Table'
--AND fact.DatabaseId = 2
--AND pkg_fact.factTableName IS NULL
