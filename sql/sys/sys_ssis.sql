-- Integration Services Tables (Transact-SQL) https://msdn.microsoft.com/en-us/library/ms181701.aspx
-- SQL Server Agent Tables (Transact-SQL) https://msdn.microsoft.com/en-us/library/ms181367.aspx

--:connect STDBDECSUP02
USE DQMF
GO

;WITH msdb_package_path AS (
	SELECT dir.foldername, dir.folderid, dir.parentfolderid,0 AS Level, CAST('' AS varchar(200)) AS dirpath
	FROM msdb.dbo.sysssispackagefolders AS dir
	WHERE dir.parentfolderid IS NULL
	UNION ALL
	SELECT dir.foldername, dir.folderid, dir.parentfolderid, Level + 1, CAST(dirpath AS varchar(100)) + '\' + CAST(dir.foldername AS varchar(99)) AS dirpath
	FROM msdb.dbo.sysssispackagefolders AS dir
	JOIN msdb_package_path
	ON dir.parentfolderid = msdb_package_path.folderid
), msdb_package AS (
	SELECT CAST(dirpath AS varchar(100)) + '\' + CAST(pkg.name AS varchar(99)) AS package_path, msdb_package_path.*, pkg.name AS package_name, pkg.id
	FROM msdb_package_path
	JOIN msdb.dbo.sysssispackages AS pkg
	ON pkg.folderid = msdb_package_path.folderid
), msdb_job_step AS (
	SELECT 
		job.name AS job_name
		,step.step_name
		,msdb_package.package_name
		,step.last_run_date
		,step.last_run_outcome
		,job.date_created
		,job.date_modified
		,step.step_id
		,step.command
		,msdb_package.package_path
		,step.last_run_duration
		,step.subsystem
			
	FROM msdb.dbo.sysjobsteps AS step
	JOIN msdb.dbo.sysjobs AS job
	ON step.job_id = job.job_id
	JOIN msdb.dbo.sysjobactivity AS act
	ON job.job_id = act.job_id
	LEFT JOIN msdb_package
	ON step.command LIKE '%' + CAST(msdb_package.package_path AS varchar(500)) + '%' 
)
SELECT msdb_job_step.*
FROM msdb_job_step
WHERE 1=1
AND msdb_job_step.package_name IN 
(
	SELECT PkgName 
	FROM DQMF.dbo.ETL_Package
)
ORDER BY last_run_date DESC