USE DQMF
GO

SELECT ActionDescription, DQMF_Action.ActionID
	,COUNT(*) AS total
	,SUM(CASE 
			WHEN TargetObjectPhysicalName IS NULL OR TargetObjectPhysicalName = ''
				THEN 0
			ELSE 1
			END) AS TargetObjectPhysicalName
	,SUM(CASE 
			WHEN TargetObjectAttributePhysicalName IS NULL OR TargetObjectAttributePhysicalName = ''
				THEN 0
			ELSE 1
			END) AS TargetObjectAttributePhysicalName
	,SUM(CASE 
			WHEN SourceObjectPhysicalName IS NULL OR SourceObjectPhysicalName = ''
				THEN 0
			ELSE 1
			END) AS SourceObjectPhysicalName
	,SUM(CASE 
			WHEN SourceAttributePhysicalName IS NULL OR SourceAttributePhysicalName = ''
				THEN 0
			ELSE 1
			END) AS SourceAttributePhysicalName
	,SUM(CASE 
			WHEN FactTableObjectAttributeName IS NULL OR FactTableObjectAttributeName = ''
				THEN 0
			ELSE 1
			END) AS FactTableObjectAttributeName
	,SUM(CASE 
			WHEN FactTableObjectAttributeId IS NULL OR FactTableObjectAttributeId = ''
				THEN 0
			ELSE 1
			END) AS FactTableObjectAttributeId
FROM dbo.DQMF_BizRule
INNER JOIN dbo.DQMF_Action
	ON DQMF_BizRule.ActionID = DQMF_Action.ActionID
WHERE IsActive = 1
GROUP BY ActionDescription,DQMF_Action.ActionID

SELECT *
FROM DQMF_BizRule
WHERE TargetObjectPhysicalName IS NULL OR TargetObjectPhysicalName = ''
AND ActionID = 4