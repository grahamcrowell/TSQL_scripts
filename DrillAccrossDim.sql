USE CommunityMart
GO

DECLARE @Xquery varchar(max)
	,@Yquery varchar(max)
	,@aggOp varchar(max)
	,@whereAnd varchar(max)
	,@groupBy varchar(max);

SET @Xquery = 'SELECT * FROM ReferralFact'
SET @Yquery = 'SELECT * FROM ReferralFact'
SET @aggOp = 'COUNT(*)'
SET @whereAnd = 'X.SourceSystemClientID = Y.SourceSystemClientID '
SET @groupBy = 'X.LocalReportingOfficeID, Y.LocalReportingOfficeID'

BEGIN
DECLARE @sql varchar(max);



SET @sql = '
;WITH X AS (
	<Xquery>
), Y AS (
	<Yquery>
)
SELECT <aggOp>,
	<groupBy>
FROM X
CROSS JOIN Y
WHERE 1=1
<whereAnd>
GROUP BY
<groupBy>
;';

SET @sql = REPLACE(@sql, '<Xquery>', @Xquery);
SET @sql = REPLACE(@sql, '<Yquery>', @Yquery);
SET @sql = REPLACE(@sql, '<aggOp>', @aggOp);
SET @sql = REPLACE(@sql, '<whereAnd>', @whereAnd);
SET @sql = REPLACE(@sql, '<groupBy>', @groupBy);
END

PRINT @sql;
EXEC(@sql);