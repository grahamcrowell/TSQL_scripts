USE DSDW
GO

DECLARE @RandTeamID int;
DECLARE @RandTeam varchar(100);

SELECT TOP 1 
	@RandTeamID = lro.LocalReportingOfficeID
	,@RandTeam = lro.ParisTeamName
FROM Dim.LocalReportingOffice AS lro
ORDER BY NEWID();

SELECT @RandTeamID AS LocalReportingOfficeID
	,@RandTeam AS ParisTeamName



SELECT 
	lro.ParisTeamName
	,dt.FiscalYearLong
	,COUNT(DISTINCT per.PatientID) AS [Referral Clients]
	,COUNT(DISTINCT ref.SourceReferralID) AS [Client Referrals]
	,COUNT(DISTINCT ed.VisitID) AS [Referral Client ED Visits]
FROM CommunityMart.dbo.ReferralFact AS ref
JOIN CommunityMart.Dim.LocalReportingOffice AS lro
ON ref.LocalReportingOfficeID = lro.LocalReportingOfficeID
JOIN CommunityMart.dbo.PersonFact AS per
ON ref.SourceSystemClientID = per.SourceSystemClientID
LEFT JOIN EDMart.dbo.ED_Visit AS ed
ON ed.PatientID = per.PatientID
AND ref.ReferralDateID <= ed.VisitKeyDateID
AND ISNULL(ref.dischargedateid, ed.VisitKeyDateID) >= ed.VisitKeyDateID
LEFT JOIN CommunityMart.Dim.Date AS dt
ON dt.DateID = ed.VisitKeyDateID
AND ref.ReferralDateID <= ed.VisitKeyDateID
AND ISNULL(ref.dischargedateid, ed.VisitKeyDateID) >= ed.VisitKeyDateID

GROUP BY lro.ParisTeamName
	,dt.FiscalYearLong
