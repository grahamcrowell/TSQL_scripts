--#region Report Cut Off - Full fiscal years
/*
	insert at top of Date and Fact import queries
	then filter DateID with: 
		@pStartDateID
		@pEndDateID
*/

DECLARE @pStartDateID int;
DECLARE @pEndDateID int;
DECLARE @date_full_fiscal_years int = 3;
DECLARE @debug int = 10;
BEGIN
	DECLARE @max_source_update_date date;
	
	
	/*
		change to fact table for each report:
	*/
			SELECT @max_source_update_date=MAX(SourceUpdateDate) 
			FROM dbo.[YouthClinicActivityFact];
	
	IF @debug > 0
		SELECT @max_source_update_date AS [MAX(SourceUpdateDate)];


	-- get most recent complete fiscal period
	DECLARE @most_recent_period_end date;
	SELECT @most_recent_period_end = DATEADD(day,-1,FiscalPeriodStartDate)
	FROM Dim.Date AS dt
	WHERE dt.ShortDate = @max_source_update_date;
	IF @debug > 0
		SELECT @most_recent_period_end AS [DATEADD(day,-1,FiscalPeriodStartDate)];
	SELECT @pEndDateID = CONVERT(varchar(8),@most_recent_period_end,112);
	-- get fiscal year and period
	DECLARE @fiscal_year int;
	DECLARE @fiscal_period int;
	SELECT @fiscal_period=dt.FiscalPeriod, @fiscal_year=dt.FiscalYearLong
	FROM Dim.Date dt
	WHERE dt.FiscalPeriodEndDate=@most_recent_period_end
	IF @debug > 0
		SELECT @fiscal_period AS MostRecentCompleteFiscalPeriod, @fiscal_year AS MostRecentCompleteFiscalYearLong;


	IF @fiscal_period < 13
	BEGIN 
		IF @debug > 0
			SELECT FORMATMESSAGE('FiscalYear %i is incomplete.', @fiscal_year)  AS IsCurrentYearFull
		IF @debug > 0
			SELECT FORMATMESSAGE('start: FiscalYear %i',@fiscal_year - @date_full_fiscal_years) AS ReportStart
		IF @debug > 0
			SELECT FORMATMESSAGE('end: Fiscal %i-%i',@fiscal_year,@fiscal_period) AS ReportEnd
		SELECT @pStartDateID = CONVERT(varchar(8),FiscalPeriodStartDate,112) 
		FROM Dim.Date 
		WHERE FiscalYearLong = @fiscal_year-@date_full_fiscal_years 
		AND FiscalPeriod = 1
	END
	ELSE
	BEGIN 
		IF @debug > 0
			SELECT FORMATMESSAGE('start: FiscalYear %i',@fiscal_year - (@date_full_fiscal_years-1)) AS ReportStart
		IF @debug > 0
			SELECT FORMATMESSAGE('end: Fiscal %i-%i',@fiscal_year,@fiscal_period) AS ReportEnd
		SELECT @pStartDateID = CONVERT(varchar(8),FiscalPeriodStartDate,112) 
		FROM Dim.Date 
		WHERE FiscalYearLong = @fiscal_year-(@date_full_fiscal_years-1)
		AND FiscalPeriod = 1
	END
	IF @debug > 0
		SELECT FORMATMESSAGE('%i to %i',@pStartDateID,@pEndDateID) AS ReportDateScope
		
END
--#endregion Report Cut Off - Full fiscal years