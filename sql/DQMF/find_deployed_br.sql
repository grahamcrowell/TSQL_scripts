SELECT
	--defaultvalue,
	----brs.*,'',sc.*,'',
	--br.isactive,br.comment,
	br.guid
	,p.PkgName
	,s.StageOrder
	,StageName
	,br.*
	,brlm.*
FROM dbo.ETL_Package p
INNER JOIN DQMF.dbo.DQMF_Schedule sc
	ON p.PKGID = sc.PkgKey
INNER JOIN DQMF.dbo.DQMF_Stage s
	ON sc.StageID = s.StageID
LEFT JOIN [dbo].[DQMF_BizRuleSchedule] brs
	ON sc.DQMF_ScheduleId = brs.ScheduleId
LEFT JOIN [dbo].[DQMF_BizRule] br
	ON brs.BRID = br.BRID
LEFT JOIN DQMF.dbo.DQMF_BizRuleLookupMapping brlm
	ON br.BRId = brlm.BRId
WHERE p.PkgName = 'PopulateCommunityMart'
	AND ActionID = 1
