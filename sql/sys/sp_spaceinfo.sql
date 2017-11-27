USE [master]

GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_spaceinfo]') AND type in (N'P', N'PC'))

DROP PROCEDURE [dbo].[sp_spaceinfo]

GO

CREATE PROCEDURE [dbo].[sp_spaceinfo] 

AS
BEGIN

	SET NOCOUNT ON;
	-- https://gallery.technet.microsoft.com/T-SQL-to-Get-Drive-Space-4b0cc810
	DECLARE @psinfo TABLE(data  NVARCHAR(100)) ;

	INSERT INTO @psinfo

	EXEC xp_cmdshell 'Powershell.exe "Get-WMIObject Win32_LogicalDisk -filter "DriveType=3"| Format-Table DeviceID, FreeSpace, Size"'  ;

	DELETE FROM @psinfo WHERE data is null  or data like '%DeviceID%' or data like '%----%';

	update @psinfo set data = REPLACE(data,' ',',');

	DECLARE @drive_info TABLE (Drive varchar(10), FreeSpaceGB numeric(8,2), SizeGB numeric(8,2), PercentRemaining numeric(8,2));

	;With DriveSpace as (

	select SUBSTRING(data,1,2)  as [Drive], replace((left((substring(data,(patindex('%[0-9]%',data)) , len(data))),CHARINDEX(',',

	(substring(data,(patindex('%[0-9]%',data)) , len(data))))-1)),',','')

	as [FreeSpace] , replace(right((substring(data,(patindex('%[0-9]%',data)) , len(data))),PATINDEX('%,%', 

	(substring(data,(patindex('%[0-9]%',data)) , len(data))))) ,',','')

	as [Size] from @psinfo

	) 

	INSERT INTO @drive_info
	SELECT Drive, convert(dec( 6,2),CONVERT(dec(17,2),FreeSpace)/(1024*1024*1024)) as FreeSpaceGB, convert(dec( 6,2),CONVERT(dec(17,2), size)/(1024*1024*1024)) as SizeGB 
	,CAST(100*convert(dec( 6,2),CONVERT(dec(17,2),FreeSpace)/(1024*1024*1024))/convert(dec( 6,2),CONVERT(dec(17,2), size)/(1024*1024*1024)) AS numeric(3,1)) AS PercentRemaining
	FROM DriveSpace

	DECLARE @LowDriveSpaceCount INT = 0;

	SELECT @LowDriveSpaceCount = COUNT(*)
	FROM @drive_info
	WHERE PercentRemaining < 10;



	IF @LowDriveSpaceCount > 0
	BEGIN
		DECLARE @DriveInfoMessage VARCHAR(8000);

		SELECT @DriveInfoMessage = COALESCE(@DriveInfoMessage + CHAR(10)+'', '') + Drive + '\ ' +  CAST(PercentRemaining AS varchar(100)) + '% Free Space'
		FROM @drive_info

		SELECT @DriveInfoMessage

		EXEC msdb.dbo.sp_send_dbmail  
			--@profile_name = 'Database Support',  
			@profile_name = 'DecisionSupport',  
			@recipients = 'graham.crowell@vch.ca',  
			@body = @DriveInfoMessage,  
			--@body = 'hello',  
			@subject = 'Automated Success Message' ;  
	END
END
GO


--CREATE TABLE #DriveSpace (
--	Drive varchar(10), FreeSpaceGB numeric(8,2), SizeGB numeric(8,2), PercentRemaining numeric(8,2)
--);

--INSERT INTO #DriveSpace
EXEC sp_spaceinfo;

--SELECT *
--FROM #DriveSpace
--WHERE PercentRemaining < 10.

Go