USE CommunityMart
GO

DECLARE @start int;
DECLARE @end int;

WITH anchor_date AS (
	SELECT CONVERT(varchar(10),MAX(SourceUpdateDate),112) AS anchor
	FROM dbo.YouthClinicActivityFact
),
end_cut_off AS (
	SELECT CONVERT(varchar(10),DATEADD(day,-1,FiscalPeriodStartDate),112) AS EndOfPrevPeriod
		,FiscalYearLong AS FiscalYearOfPrevFiscalPeriod
		,anchor_date.anchor
	FROM Dim.Date AS dt
	JOIN anchor_date
	ON anchor_date.anchor = dt.DAteID
),
start_cut_off AS (
	SELECT CONVERT(varchar(10),MIN(dt.FiscalPeriodStartDate),112) StartOf3FiscalYearsAgo
		,end_cut_off.EndOfPrevPeriod
		,end_cut_off.anchor
	FROM Dim.Date AS dt
	JOIN end_cut_off
	ON end_cut_off.FiscalYearOfPrevFiscalPeriod-3 = dt.FiscalYearLong
	GROUP BY end_cut_off.EndOfPrevPeriod
		,end_cut_off.anchor
)
SELECT @start=StartOf3FiscalYearsAgo
	,@end=EndOfPrevPeriod
FROM start_cut_off


SELECT @start AS StartOf3FiscalYearsAgo
	,@end AS EndOfPrevPeriod

