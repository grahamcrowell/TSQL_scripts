USE gcDev
GO

SELECT DB_NAME(files.database_id) AS DatabaseName,
files.Name AS Logical_Name,
files.Physical_Name, (size*8)/1024 SizeMB
,db.recovery_model_desc
,db.log_reuse_wait_desc
,files.file_id
,files.file_guid
FROM sys.master_files AS files
JOIN sys.databases AS db
ON files.database_id = db.database_id
WHERE 1=1
AND file_id = 2
AND db.name = 'gcDev'
ORDER BY size DESC

--gcTest	gcTest_log	I:\SQL_Log\gcTest_log.ldf	8973	FULL	NOTHING	2	5F12071B-95A8-450B-940E-375231B27112
--gcTest	gcTest	H:\SQL_Data\gcTest.mdf	977	FULL	NOTHING	1	36708549-4011-4A7C-8E44-A30969741FBE
-- gcDev	gcDev_log	I:\SQL_Log\gcDev_log.ldf	1333	FULL	NOTHING	2	FA7E7843-7A39-421E-878F-C00E1B835BDA



DBCC SQLPERF(LOGSPACE);
-- gcTest	0.7578125	43.62114	0
--gcDev	1333.617	1.016824	0
--gcDev	1333.617	0.7198907	0
ALTER DATABASE gcDev SET RECOVERY FULL ;  

DBCC SHRINKFILE('gcDev_log')
-- 58	1	528	392	488	464 -- after backup


BACKUP LOG gcDev 
 TO DISK = 'I:\gcDev_log_bkup.bak'
   WITH FORMAT;
GO