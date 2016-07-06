USE CommunityMart
GO

DECLARE @table_name varchar(100) = 'dbo.ReferralFact'

DECLARE @cols varchar(max) = ''
SELECT @cols=SUBSTRING((
SELECT ',['+col.name +']'
FROM sys.columns AS col
WHERE object_id = OBJECT_ID(@table_name)
ORDER BY col.column_id
FOR XML PATH('')),2,5000)

SELECT @cols

SET @cols = ''
SELECT @cols=STUFF((
SELECT N',['+ ParisTeamName +N']'
FROM Dim.LocalReportingOffice AS col
ORDER BY col.ParisTeamName
FOR XML PATH(N''), TYPE).value('.', 'nvarchar(max)'),1,1,'')
SELECT @cols
PRINT @cols
