USE DQMF
GO

-- browse deployed packages
SELECT TOP 10 *
FROM DQMF.dbo.ETL_Package
WHERE PkgName LIKE '%CCRS%'
ORDER BY UpdatedDT DESC

-- set PkgName to variable 
DECLARE @PkgName varchar(100);
SET @PkgName = 'CCRS';

-- browse package execution logs
SELECT TOP 10 *
FROM dbo.AuditPkgExecution
WHERE PkgName = @PkgName
ORDER BY ExecStartDT DESC

-- a PkgExecKey is generated each time a package executes (true parent and child packages)
DECLARE @PkgExecKey varchar(100);
SET @PkgExecKey = '312137';

-- notice that parent-child package relationships can to reconciled here
SELECT TOP 10 *
FROM dbo.AuditPkgExecution
WHERE ParentPkgExecKey = @PkgExecKey
ORDER BY ExecStartDT DESC

-- browse files processed during a package execution
SELECT TOP 10 *
FROM dbo.AuditExtractFile
WHERE PkgExecKey = @PkgExecKey
ORDER BY ExtractFileProcessStartDT DESC

-- a ExtractFileKey is generated each time a file is processed
DECLARE @ExtractFileKey varchar(100);
SET @ExtractFileKey = '550102';

-- browse bizrules (WHERE DQMF_BizRule.IsLogged=1) that were executed during a file processing
SELECT TOP 10 *
FROM dbo.AuditBizRuleExecution
WHERE ExtractFileKey = @ExtractFileKey

-- browse type 4 bizrules (WHERE DQMF_BizRule.IsLogged=1) that were executed during a file processing
SELECT TOP 10 *
FROM dbo.AuditBizRuleAction4Execution
WHERE ExtractFileKey = @ExtractFileKey


-- all together now...
-- everything that was logged during a package execution
USE DQMF
GO

DECLARE @PkgName varchar(100);
SET @PkgName = 'CCRS'

;WITH parent_pkg AS (
SELECT 
	TOP 100 
	--*
	--child_pkg_exec.*
	--,child_br_exec.*
	par_pkg_exec.*
FROM dbo.AuditPkgExecution AS par_pkg_exec
--LEFT JOIN dbo.AuditExtractFile AS ext_file
--ON par_pkg_exec.PkgExecKey = ext_file.PkgExecKey
--LEFT JOIN dbo.AuditBizRuleExecution AS br_exec
--ON ext_file.ExtractFileKey = br_exec.ExtractFileKey
--LEFT JOIN dbo.AuditBizRuleAction4Execution AS br4_exec
--ON ext_file.ExtractFileKey = br4_exec.ExtractFileKey
--JOIN dbo.AuditPkgExecution AS child_pkg_exec
--ON par_pkg_exec.PkgExecKey = child_pkg_exec.ParentPkgExecKey
WHERE par_pkg_exec.PkgName = @PkgName
), child_package AS (

SELECT 
	child_pkg_exec.*
FROM parent_pkg
JOIN dbo.AuditPkgExecution AS child_pkg_exec
ON parent_pkg.PkgExecKey = child_pkg_exec.ParentPkgExecKey
)
SELECT *
FROM parent_pkg
UNION ALL
SELECT *
FROM child_package
ORDER BY ExecStartDT, ParentPkgExecKey

--LEFT JOIN dbo.AuditExtractFile AS child_ext_file
--ON parent_pkg.PkgExecKey = ext_file.PkgExecKey
----LEFT JOIN dbo.AuditBizRuleExecution AS child_br_exec
----ON child_ext_file.ExtractFileKey = child_br_exec.ExtractFileKey
----LEFT JOIN dbo.AuditBizRuleExecution AS child_br4_exec
----ON child_ext_file.ExtractFileKey = child_br4_exec.ExtractFileKey

--WHERE par_pkg_exec.PkgName = @PkgName
----AND child_br_exec.BRID IS NOT NULL