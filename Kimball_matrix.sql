USE CommunityMart
GO

DECLARE @output varchar(max);

;WITH col AS (
	SELECT col.name, COUNT(*) cnt
	FROM sys.columns AS col
	JOIN sys.tables AS tab
	ON col.object_id = tab.object_id
	WHERE tab.type = 'U'
	GROUP BY col.name
),
col_order AS (
	SELECT *, ROW_NUMBER() OVER(ORDER BY col.cnt DESC) AS rn
	FROM col
),
tab AS (
	SELECT *
	FROM sys.tables AS tab
)
SELECT @output = COALESCE(@output + '], [', '') + CAST(name AS varchar(100))
FROM col_order
ORDER BY col_order.rn DESC
SET @output = '['+@output+']';
PRINT @output;



--;WITH col AS (
--	SELECT DISTINCT
--		col.name AS column_name
--	FROM sys.columns AS col
--	JOIN sys.tables AS tab
--	ON col.object_id = tab.object_id
--	WHERE tab.type = 'U'
--),
--tab AS (
--	SELECT 
--		col.name AS column_name
--		,tab.name AS table_name
--		,1 AS has_col
--	FROM sys.columns AS col
--	JOIN sys.tables AS tab
--	ON col.object_id = tab.object_id
--	WHERE tab.type = 'U'
--)
--SELECT tab.*
--FROM col
--LEFT JOIN tab
--ON col.column_name = tab.column_name;

SELECT *
FROM (
SELECT 
	CHARINDEX(col.name,'Date',1) AS column_name
	,tab.name AS table_name
	,1 AS has_col
FROM sys.columns AS col
JOIN sys.tables AS tab
ON col.object_id = tab.object_id) AS src
PIVOT
(
	SUM(src.has_col) 
	FOR column_name IN ([IntervalLkupID], [InfectedAbscessUnitLkupID], [InfectedAbscessDuration], [ImmStatusReasonLkupID], [ImmStatusLkupID], [ImmComment], [ImmCategoryID], [ImmAlertStartDateID], [ImmAlertNote], [ImmAlertID], [ImmAlertEndDateID], [HypotonicUnitLkupID], [HypotonicDuration], [HouseTypeID], [HomeSupportServiceInterventionID], [HivesUnitLkupID], [HivesDuration], [GuillainBarreUnitLkupID], [GuillainBarreDuration], [GPMSPBillingNumber], [GPCollegeNumber], [GestationWeek], [GenderID], [FundingSourceID], [FiscalQuater], [FeverMidUnitLkupID], [FeverMidDuration], [FeverHighUnitLkupID], [FeverHighNotRecordedUnitLkupID], [FeverHighNotRecordedDuration], [FeverHighDuration], [EventDateID], [IsInternalVCHReferral], [IsInitialConsultation], [IsInfectedAbscess], [IsImmunizationReviewed], [IsImmunizationGiven], [IsImmsInvalid], [IsHypotonic], [IsHRPURS3Plus], [IsHRPsychotropicMedication], [IsHRPain2Plus], [IsHRNoCaregiver], [IsHRMedicationsNine], [IsHRMAPLe4Plus], [IsHRDRS3Plus], [IsHRDelirium], [IsHRCPS3Plus], [IsHRCHESS3Plus], [IsHRCaregiverStress], [IsHRADLSPH3Plus], [IsHomeless], [IsHives], [IsGuillainBarre], [IsGroupSession], [IsFirstServiceEvent], [IsFeverMid], [IsFeverHighNotRecorded], [IsFeverHigh], [IsExternalVCHReferral], [IsExternalReferral], [IsEstimatedDate], [IsEoS], [IsEncephalopathy], [IsEdema], [IsDrNPConsultation], [IsDefaultReferral], [IsDeathConfirmed], [IsCrying], [IsConvulsion], [IsContraceptionIUDInsertion], [IsContraceptionInitial], [IsContraceptionFollowUp], [IsContLive], [IsConsultationReview], [IsClientLeftNotSeen], [IsCaseConference], [IsCancelledByStaff], [IsCancelledByClient], [IsBodyImage], [IsAssessment], [IsAnaphylaxis], [IsAnaesthesia], [IsAllergicReaction], [IsAdenopathy], [IsAddressCurrent], [InvoicePaidDateID], [InvoiceDownloadDateID], [InterventionTypeID], [EncephalopathyUnitLkupID], [EncephalopathyDuration], [EdemaUnitLkupID], [EdemaDuration], [DurationUnitLkupID], [Duration], [DRSScore], [DRS3PlusClientCount], [DoseNumber4], [DoseNumber3], [DoseNumber2], [DoseNumber1], [DosageUnitLkupID], [DosageAmt], [DistinctActiveClientCount], [DischargeDateID], [DeliriumClientCount], [DeathTimeID], [DeathNotifyID], [DeathLocationID], [DeathDateID], [DeathConfirmedTimeID], [DeathConfirmedDateID], [DaysToCompleteAx], [DaysBetweenAx], [DateRecordedID], [DateGivenID], [DateAvailableID], [DateActiveID], [CustomClientGroupID], [CurrentLocationAddress], [CryingUnitLkupID], [CryingDuration], [CriminalJusticeTypeID], [CriminalJusticeInvolvementID], [AllocatedStaffType], [AllergicReactionUnitLkupID], [AllergicReactionDuration], [AlertLkupID], [AlertInactiveDateID], [AlertDateID], [AgeGroup3MVHHSC], [AgeAtVisitID], [AgeAtAssessmentID], [AdmissionDateID], [ADLSPHierarchy], [ADLSPH3PlusClientCount], [AdenopathyUnitLkupID], [AdenopathyDuration], [AddressTypeID], [AddressLine3], [AddressLine2], [AddressLine1], [AcutalDischargeDateID], [ActivityDateID], [A2AssessmentReasonCIHIValue], [A2AssessmentReason], [A1AssessmentDateID], [CommunityLHADesc], [ClinicalServiceLkupID], [ClientSurname], [ClientNotifiedDateID], [ClientGroupID], [ClientFirstName], [ClassTypeLkupID], [ClassStartDateID], [ClassNameLkupID], [ClassEndDateID], [City], [CHESSScore], [CHESS3PlusClientCount], [CaseOpenedDateID], [CarePlanUsageLkupID], [CarePlanPattern], [IsUserStatus], [IsUserStage], [IsTobaccoReductionCessation], [IsThrombocytopenia], [IsTherapyRecommended], [IsTherapy], [IsTakeOn], [IsSwollenPainfulJoints], [IsSwellPainPastJoint], [IsSubstanceUse], [IsSTIPreTestCounselling], [IsSTIPostTestCounselling], [IsSTIPAPResultsFollowUp], [IsSTIFollowupTreatment], [IsSTICounselling], [IsSterileAbscess], [IsSSPE], [IsSomnolence], [IsSexualOrientation], [IsSevereUnusualOther], [IsSchoolYrHolding], [IsSchoolYrGraduation], [IsSchoolYrActive], [IsSameSexRoom], [IsReproductiveHealth], [IsRelationshipSafety], [IsRedSwellPainMid], [IsRedSwellPainLong], [IsRedSwellLarge], [IsRecall], [IsRashMid], [IsRashLong], [IsPuffiness], [IsPriorityAccess], [IsPregnancyOptionsCounselling], [IsPhoneCall], [IsPHNurseConsultation], [IsParotitis], [IsParalysis], [IsOutreachVisit], [IsOtherHealthPromotion], [IsOtherCareProvided], [IsOrchitis], [IsOnHoldTherapy], [IsOnHoldAssessment], [IsOfficeVisit], [IsObservation], [IsNutritionExercise], [IsNoShow], [IsNonSTITestOrdered], [IsMentalHealth], [IsMeningitis], [PmpDateID], [PayCostTypeLkupID], [PayCostLinkTypeLkupID], [PatientID], [ParotitisUnitLkupID], [ParotitisDuration], [ParisTeamName], [ParalysisUnitLkupID], [ParalysisDuration], [PainScaleScore], [Pain2PlusClientCount], [OutcomeDateID], [OrgSchoolCategoryLkupID], [OrchitisUnitLkupID], [OrchitisDuration], [OfferDateID], [OccurrenceStartTimeID], [OccurrenceStartDateID], [OccurrenceEndTimeID], [OccurrenceEndDateID], [OccurenceTypeLkupID], [Occurences], [NoCaregiverClientCount], [NameTypeLkupID], [NameTitleLkupID], [MeningitisUnitLkupID], [MeningitisDuration], [MedicationsNineClientCount], [MeasureID], [Measure], [MAPLeScore], [MAPLe4PlusClientCount], [Manufacture4], [Manufacture3], [Manufacture2], [Manufacture1], [LotNumber4], [LotNumber3], [LotNumber2], [LotNumber1], [LotNumber], [LocationTypeID], [LocationCategoryID], [ScreeningServiceLkupID], [ScreeningEventResultID], [ScreeningEventID], [SchoolYrStartDateID], [SchoolYrLkupID], [SchoolYrEndDateID], [SchoolStartDateID], [SchoolLeavingReasonLkupID], [EstimatedDischargeDateID], [CaregiverStressClientCount], [BodySiteLkupID], [CPTypeLkupID], [CPSScore], [CPS3PlusClientCount], [CPLinkTypeLkupID], [Antigen4ID], [Antigen3ID], [Antigen2ID], [Antigen1ID], [AnaphylaxisUnitLkupID], [AnaphylaxisDuration], [AnaesthesiaUnitLkupID], [AnaesthesiaDuration], [ConvulsionUnitLkupID], [ConvulsionDuration], [ContactTypeCodeID], [ContactDateID], [CommunityRegionDesc], [CommunityProgramGroup], [SchoolEndDateID], [SchoolDtlStartDateID], [SchoolDtlEndDateID], [SchoolCode], [RUGSID], [RoomNumber], [RoomGenderID], [RoleTypeLkupID], [ReplyDateID], [ReferralRelationshipID], [ReferralReasonServiceGroup], [ReferralReasonID], [ReferralActionTypeLkupID], [RedSwellPainMidUnitLkupID], [RedSwellPainMidDuration], [RedSwellPainLongUnitLkupID], [RedSwellPainLongDuration], [RedSwellLargeUnitLkupID], [RedSwellLargeDuration], [RecordStatusID], [RecordStatus], [RecallWeeks], [RecallStaffCode], [RecallSourceSchoolID], [RecallSourceLicID], [RecallScreeningEventID], [RecallLocalReportingOfficeID], [RecallDateID], [ReactionReportedDateID], [RashMidUnitLkupID], [RashMidDuration], [RashLongUnitLkupID], [RashLongDuration], [R1cSignCompletedDateID], [PURSScale], [PURS3PlusClientCount], [PuffinessUnitLkupID], [PuffinessDuration], [PsychotropicMedicationClientCount], [X70AssessmentLocationCIHIValue], [X70AssessmentLoc], [WheezingUnitLkupID], [WheezingDuration], [WaitlistTypeID], [WaitlistSuspensionReasonID], [WaitlistStatusID], [WaitlistReasonRejectedID], [WaitlistReasonOfferRemovedID], [WaitlistReasonNotOfferedID], [WaitListReasonID], [WaitlistProviderOfferStatusID], [WaitlistPriorityID], [WaitlistPreference], [WaitlistPosition], [WaitlistOfferOutcomeID], [WaitlistName], [WaitlistClientOfferStatusID], [VomitingDiarrheaUnitLkupID], [VomitingDiarrheaDuration], [VisitMinutes], [VisitHours], [VisitDateID], [ViolenceAbuseID], [VaccineGivenDateID], [UDFTable], [TradeName], [ThrombocytopeniaUnitLkupID], [ThrombocytopeniaDuration], [SystemUpdateDate], [SwollenPainfulJointsUnitLkupID], [SwollenPainfulJointsDuration], [SwellPainPastJointUnitLkupID], [SwellPainPastJointDuration], [SuicideAttemptID], [SterileAbscessUnitLkupID], [SterileAbscessDuration], [LHAID], [IsYouthCounsellorConsultation], [IsWrittenNotification], [IsWheezing], [IsVomitingDiarrhea], [SourceCaseNoteClinicalServiceKey], [SourceCarePlanProfileID], [SourceAlertID], [SourceAdverseEventID], [SourceAddressID], [SourceAbuseID], [SomnolenceUnitLkupID], [SomnolenceDuration], [Site4LkupID], [Site3LkupID], [Site2LkupID], [Site1LkupID], [SevereUnusualOtherUnitLkupID], [SevereUnusualOtherDuration], [SourceEntryID], [SourceDeathID], [SourceCVPLinkID], [SourceCurrentLocationID])
) AS piv;

SELECT *
FROM sys.tables AS tab
WHERE tab.type = 'U';


GO

DECLARE @output varchar(max);

;WITH col AS (
	SELECT col.name, COUNT(*) cnt
	FROM sys.columns AS col
	JOIN sys.tables AS tab
	ON col.object_id = tab.object_id
	WHERE tab.type = 'U'
	AND col.name NOT LIKE 'Is%'
	GROUP BY col.name
),
tab AS (
	SELECT *
	FROM sys.tables AS tab
)
SELECT @output = COALESCE(@output + '], [', '') + CAST(name AS varchar(100))
FROM col
ORDER BY col.cnt DESC
SET @output = '['+@output+']';
PRINT @output;

DECLARE @sql varchar(max);

SET @sql = '
SELECT *
FROM (
SELECT 
	col.name AS column_name
	,tab.name AS table_name
	,1 AS has_col
FROM sys.columns AS col
JOIN sys.tables AS tab
ON col.object_id = tab.object_id) AS src
PIVOT
(
	SUM(src.has_col) 
	FOR column_name IN ('+@output+')
) AS piv;
';

EXEC(@sql);