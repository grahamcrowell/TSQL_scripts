USE DQMF
GO



--DELETE DQMF.dbo.DQMF_BizRule
--FROM DQMF.dbo.DQMF_BizRule AS br
---- 32 is CommunityMart
--WHERE br.DatabaseId = 32

UPDATE DQMF.dbo.DQMF_BizRule
SET IsActive = 0
FROM DQMF.dbo.DQMF_BizRule AS br
-- 32 is CommunityMart
WHERE br.DatabaseId = 32


UPDATE DQMF.dbo.DQMF_BizRule
SET IsActive = 1
FROM DQMF.dbo.DQMF_BizRule AS br
-- 32 is CommunityMart
WHERE br.DatabaseId = 32
AND br.TargetObjectPhysicalName LIKE '%BirthFact%'
AND br.Sequence BETWEEN 499 AND 600
--AND br.Sequence = 500
GO

SELECT *
FROM DQMF.dbo.DQMF_BizRule AS br
-- 32 is CommunityMart
WHERE br.DatabaseId = 32
AND IsActive = 1

-- ExecDQMFBizRule is what packages execute
-- each ExecDQMFBizRule call executes a single stage
EXEC DSDW.dbo.ExecDQMFBizRule 'CommunityMart Post Process', 1, @debug = 10
GO

UPDATE DQMF.dbo.DQMF_BizRule
SET IsActive = 1
FROM DQMF.dbo.DQMF_BizRule AS br
-- 32 is CommunityMart
WHERE br.DatabaseId = 32
GO

SELECT COUNT(*)
FROM CommunityMart.dbo.BirthFact