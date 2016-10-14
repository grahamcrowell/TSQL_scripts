DECLARE @pkg_name varchar(100) = 'PopulateCommunityMart'

;WITH pkg_aud AS (
SELECT TOP 100 pkg_aud.*,file_aud.ExtractFileKey
FROM DQMF.dbo.ETL_Package AS pkg
JOIN DQMF.dbo.AuditPkgExecution AS pkg_aud
ON pkg.PkgID = pkg_aud.PkgKey
JOIN DQMF.dbo.AuditExtractFile AS file_aud
ON file_aud.PkgExecKey = pkg_aud.PkgExecKey
WHERE 1=1
AND pkg.PkgName = @pkg_name
)
,br_aud AS (
SELECT br_aud.*, br.ShortNameOfTest, br.ActionSQL
FROM DQMF.dbo.AuditBizRuleExecution AS br_aud
JOIN DQMF.dbo.DQMF_BizRule AS br
ON br.BRId = br_aud.BRID
)
SELECT br_aud.*
FROM pkg_aud
JOIN br_aud
ON br_aud.ExtractFileKey = pkg_aud.ExtractFileKey
ORDER BY pkg_aud.ExecStartDT DESC, br_aud.ExecutionDate DESC