USE gcTestData
GO

SELECT TOP 5 PERCENT *
FROM gcTestData.Dim.LocalReportingOffice AS lro_dim

;WITH del_ids AS (
	SELECT TOP 10 LocalReportingOfficeID 
	FROM gcTestData.Dim.LocalReportingOffice 
	ORDER BY NEWID()
)
DELETE del_tab
FROM gcTestData.Dim.LocalReportingOffice AS del_tab
JOIN del_ids
ON del_tab.LocalReportingOfficeID = del_ids.LocalReportingOfficeID



;WITH ins_ids AS (
	SELECT TOP 30 PERCENT LocalReportingOfficeID 
	FROM gcTestData.Dim.LocalReportingOffice 
	ORDER BY NEWID()
	-- UNION
	-- SELECT TOP 20 PERCENT LocalReportingOfficeID 
	-- FROM gcTestData.Dim.LocalReportingOffice 
	-- ORDER BY NEWID()
	-- UNION
	-- SELECT TOP 20 PERCENT LocalReportingOfficeID 
	-- FROM gcTestData.Dim.LocalReportingOffice 
	-- ORDER BY NEWID()
)
INSERT INTO gcTestData.Dim.LocalReportingOffice
SELECT 
	del_tab.LocalReportingOfficeID*-1 AS LocalReportingOfficeID
	,CommunityProgramID
	,ParisTeamKey
	,ParisTeamCode
	,ParisTeamName
	,PostalCode
	,City
	,CommunityLHAID
	,CommunityRegionID
	,IsAmbulatoryService
	,ParisTeamGroup
	,LROSubProgram
	,IsTCUTeam
	,IsALTeam
	,ProviderID
	,IsHCCMRRExclude
	,IsPriorityAccess
FROM gcTestData.Dim.LocalReportingOffice AS del_tab
JOIN ins_ids
ON del_tab.LocalReportingOfficeID = ins_ids.LocalReportingOfficeID

