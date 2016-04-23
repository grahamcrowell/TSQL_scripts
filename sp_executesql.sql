DECLARE @sql nvarchar(max);
DECLARE @param nvarchar(max);

DECLARE @count int;
DECLARE @lro int;

SET @lro = 197;
SET @sql = N'
SELECT @countOUT = COUNT(*)
FROM DSDW.Community.ReferralFact AS ref_fact
WHERE ref_fact.LocalReportingOfficeID = @lroIN';
SET @param = N'
@lroIN int
,@countOUT int OUTPUT';

EXECUTE sp_executesql @sql
	,@param
	,@lroIN = @lro, @countOUT = @count OUTPUT;

SELECT @count AS cnt;