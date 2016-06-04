USE DSDW
GO

SELECT CONCAT(FiscalYearLong,'-', LEFT('0',2-LEN(CAST(FiscalPeriod AS varchar(2)))),FiscalPeriod) AS FiscalPeriod, CAST(FiscalPeriodStartDate AS date) AS StartDate, CAST(FiscalPeriodEndDate AS date) AS EndDate
FROM Dim.Date AS dt
WHERE dt.FiscalYearLong < 2018
AND YEAR(dt.ShortDate) >= YEAR(CAST(GETDATE() AS date))-4
GROUP BY FiscalYearLong, FiscalPeriod, FiscalPeriodStartDate, FiscalPeriodEndDate
ORDER BY FiscalYearLong DESC, FiscalPeriod DESC
