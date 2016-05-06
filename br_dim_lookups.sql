USE DQMF
GO

SELECT
br.guid,
p.PkgName
,s.StageOrder,StageName
,br.*
,brlm.*
FROM dbo.ETL_Package p
join DQMF.dbo.DQMF_Schedule sc
on p.PKGID = sc.PkgKey
join DQMF.dbo.DQMF_Stage s
on sc.StageID = s.StageID
left outer join [dbo].[DQMF_BizRuleSchedule] brs
on sc.DQMF_ScheduleId = brs.ScheduleId
left outer join [dbo].[DQMF_BizRule]  br
on brs.BRID = br.BRID
left outer join DQMF.dbo.DQMF_BizRuleLookupMapping brlm
on br.BRId = brlm.BRId
WHERE  p.PkgName = 'CommunityLoadDSDW'
and br.actionid=0
and br.TargetObjectPhysicalName like '%InvoiceClientVisit%'
and br.TargetObjectAttributePhysicalName like '%Service%'
ORDER BY p.PkgName,s.StageOrder,s.StageName,br.sequence 
