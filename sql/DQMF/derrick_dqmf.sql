SELECT
--defaultvalue,
----brs.*,'',sc.*,'',
--br.isactive,br.comment,
br.guid,
p.PkgName
,s.StageOrder,StageName
,brs.*
,br.*
,brlm.*
FROM DQMF.dbo.ETL_Package p
join DQMF.dbo.DQMF_Schedule sc
on p.PKGID = sc.PkgKey
join DQMF.dbo.DQMF_Stage s
on sc.StageID = s.StageID
left outer join DQMF.[dbo].[DQMF_BizRuleSchedule] brs
on sc.DQMF_ScheduleId = brs.ScheduleId
left outer join DQMF.[dbo].[DQMF_BizRule]  br
on brs.BRID = br.BRID
left outer join DQMF.dbo.DQMF_BizRuleLookupMapping brlm
on br.BRId = brlm.BRId
WHERE  p.PkgName = 'CommunityLoadDSDW'
and br.actionid=0
and 
	(br.SourceObjectPhysicalName in ('Dim.School','Dim.CommunityOrganization','Dim.CommunityLocation')
OR br.TargetObjectPhysicalName IN (
	'Staging.CommunitySchoolEducation'
	,'Staging.CommunityImmunizationHistory'
	,'Staging.CommunityImmunizationHistory'
	,'Staging.CommunityImmunizationHistory'
	,'Staging.CommunitySchoolHistory'
	,'Staging.CommunityYouthClinicActivity'
	,'Staging.CommunityScreeningResult'
	,'Staging.CommunityScreeningResult'
	,'Staging.CommunityAssessmentContact'
))
AND 
br.BRID NOT IN (114851
,117615
,117617
,117618
,117613
,117766
,117866
,117915
,117881)
ORDER BY p.PkgName,s.StageOrder,s.StageName,br.sequence 



USE [DSDW]
GO

SELECT 
	sch.name AS schema_name
	,tab.object_id
	,tab.name AS table_name
	,col.column_id
	,col.name AS column_name
	,typ.name AS type_name
FROM sys.schemas AS sch
JOIN sys.tables AS tab
ON sch.schema_id = tab.schema_id
JOIN sys.columns AS col
ON tab.object_id = col.object_id
JOIN sys.types AS typ
ON col.system_type_id = typ.system_type_id
WHERE sch.name = 'Staging'
AND tab.name IN (
	'Staging.CommunitySchoolEducation'
	,'Staging.CommunityImmunizationHistory'
	,'Staging.CommunityImmunizationHistory'
	,'Staging.CommunityImmunizationHistory'
	,'Staging.CommunitySchoolHistory'
	,'Staging.CommunityYouthClinicActivity'
	,'Staging.CommunityScreeningResult'
	,'Staging.CommunityScreeningResult'
	,'Staging.CommunityAssessmentContact'
)

