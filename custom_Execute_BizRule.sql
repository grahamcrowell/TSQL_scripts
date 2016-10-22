USE DQMF
GO



DELETE DQMF.dbo.DQMF_BizRule
FROM DQMF.dbo.DQMF_BizRule AS br
-- 32 is CommunityMart
WHERE br.DatabaseId = 32


UPDATE DQMF.dbo.DQMF_BizRule
SET IsActive = 0
FROM DQMF.dbo.DQMF_BizRule AS br
-- 32 is CommunityMart
WHERE br.DatabaseId = 32
AND br.SourceAttributePhysicalName  LIKE '%Gravida%'

UPDATE DQMF.dbo.DQMF_BizRule
SET IsActive = 1
FROM DQMF.dbo.DQMF_BizRule AS br
-- 32 is CommunityMart
WHERE br.DatabaseId = 32
AND br.TargetObjectPhysicalName LIKE '%BirthFact%'
--AND br.Sequence BETWEEN 499 AND 600
--AND br.SourceAttributePhysicalName NOT LIKE '%Gravida%'
--AND br.Sequence = 500
GO

SELECT *
FROM DQMF.dbo.DQMF_BizRule AS br
-- 32 is CommunityMart
WHERE br.DatabaseId = 32
AND IsActive = 1
AND br.Sequence BETWEEN 499 AND 600


-- ExecDQMFBizRule is what packages execute
-- each ExecDQMFBizRule call executes a single stage
EXEC DSDW.dbo.ExecDQMFBizRule 'CommunityMart Post Process', 1, @debug = 10
GO

-- set everything to active
UPDATE DQMF.dbo.DQMF_BizRule
SET IsActive = 1
FROM DQMF.dbo.DQMF_BizRule AS br
-- 32 is CommunityMart
WHERE br.DatabaseId = 32
GO

-- set everything that's inactive in TEST to inactive in DEV
UPDATE dev_br
SET IsActive = test_br.IsActive
FROM DQMF.dbo.DQMF_BizRule AS dev_br
JOIN STDBDECSUP02.DQMF.dbo.DQMF_BizRule AS test_br
ON test_br.guid = dev_br.guid
-- 32 is CommunityMart
WHERE dev_br.DatabaseId = 32
GO


SELECT COUNT(*)
FROM CommunityMart.dbo.BirthFact

SELECT *
FROM CommunityMart.dbo.BirthFact
