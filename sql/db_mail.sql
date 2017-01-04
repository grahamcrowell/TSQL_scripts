USE msdb
GO

-- check if db mail running
EXEC msdb.dbo.sysmail_help_status_sp

-- get profile to send emails
SELECT *
FROM msdb.dbo.sysmail_profile

-- try and send an email
EXEC msdb.dbo.sp_send_dbmail  
    @profile_name = 'DecisionSupport',  
    @recipients = 'graham.crowell@vch.ca',  
    @body = 'The stored procedure finished successfully.',  
    @subject = 'Automated Success Message' ;  
DECLARE @mail_id int = 7554;




SELECT *
FROM msdb.dbo.sysmail_account

SELECT *
FROM msdb.dbo.sysmail_log
--WHERE log_id = @mail_id
ORDER BY log_date DESC


SELECT *
FROM msdb.dbo.sysmail_event_log

EXECUTE msdb.dbo.sysmail_help_principalprofile_sp  
    --@principal_name = 'danw',  
    @profile_name = 'DecisionSupport';  


EXECUTE msdb.dbo.sysmail_help_configure_sp

SELECT *
FROM msdb.dbo.sysmail_account
SELECT *
FROM msdb.dbo.sysmail_profileaccount
SELECT *
FROM msdb.dbo.sysmail_server
SELECT *
FROM msdb.dbo.sysmail_log

SELECT tab.name
FROM msdb.sys.columns AS col
JOIN msdb.sys.tables AS tab
ON col.object_id=tab.object_id
WHERE col.name = 'account_id'