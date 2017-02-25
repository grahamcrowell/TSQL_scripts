

SELECT *
FROM (
	SELECT 
		job.name AS job_name
		,step_name
		,hist.run_status
		,hist.run_date
		,hist.run_time
		,CASE 
			WHEN hist.run_status = 0 
				AND LAG(hist.message) OVER(PARTITION BY job.name, step_name, hist.run_date, hist.run_time ORDER BY instance_id) IS NOT NULL 
			THEN LAG(hist.message) OVER(PARTITION BY job.name, step_name, hist.run_date, hist.run_time ORDER BY instance_id)
			ELSE hist.message
		END AS step_message
		,hist.message
		,instance_id
		,ROW_NUMBER() OVER(PARTITION BY job.name, step_name, hist.run_date, hist.run_time ORDER BY instance_id DESC) AS by_step_execution
		,ROW_NUMBER() OVER(PARTITION BY job.name, step_name ORDER BY hist.run_date DESC, hist.run_time DESC, instance_id DESC) AS by_step
		,CASE
			WHEN run_status = 0 THEN 'Failed'
			WHEN run_status = 1 THEN 'Succeeded'
			WHEN run_status = 2 THEN 'Retry'
			WHEN run_status = 3 THEN 'Cancelled'
			ELSE '???'
		END AS step_outcome
	FROM msdb.dbo.sysjobhistory AS hist
	JOIN msdb.dbo.sysjobs AS job
	ON hist.job_id = job.job_id
	WHERE step_name != '(Job outcome)'
) sub
WHERE 1=1
AND sub.by_step_execution = 1
AND sub.by_step = 1
ORDER BY sub.run_date DESC, sub.run_time DESC, sub.instance_id DESC

--SELECT sj.name,
--       sh.run_date,
--       sh.step_name,
--       STUFF(STUFF(RIGHT(REPLICATE('0', 6) +  CAST(sh.run_time as varchar(6)), 6), 3, 0, ':'), 6, 0, ':') 'run_time',
--       STUFF(STUFF(STUFF(RIGHT(REPLICATE('0', 8) + CAST(sh.run_duration as varchar(8)), 8), 3, 0, ':'), 6, 0, ':'), 9, 0, ':') 'run_duration (DD:HH:MM:SS)  '
--FROM msdb.dbo.sysjobs sj
--JOIN msdb.dbo.sysjobhistory sh
--ON sj.job_id = sh.job_id

--SELECT job.name AS job_name, step.step_name, step.subsystem, step.command, step.last_run_date, step.last_run_outcome--, pkg.name AS pkg_name
--FROM msdb.dbo.sysjobs AS job
--JOIN msdb.dbo.sysjobsteps AS step
--ON job.job_id = step.job_id
----LEFT JOIN msdb.dbo.sysssispackages AS pmsdb.dbo.sysssispackagesnd
--ORDER BY step.last_run_date DESC

--SELECT TOP 100 *
--FROM msdb.dbo.sysssispackages


--SELECT TOP 10 *
--FROM msdb.dbo.sysssislog
--ORDER BY starttime DESC