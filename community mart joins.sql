USE CommunityMart
GO

SELECT 
	--TOP 100
	COUNT(*) AS row_count
	,FLOOR(DATEDIFF(day, dim_dt_dob.ShortDate, dim_dt_dod.ShortDate)/365.25) AS years_old
	,dim_gen.GenderDesc
FROM CommunityMart.dbo.PersonFact AS per_fact
-- Person Dims
LEFT OUTER JOIN CommunityMart.Dim.Gender AS dim_gen
ON per_fact.GenderID = dim_gen.GenderID
-- Person Dates
LEFT OUTER JOIN CommunityMart.Dim.Date AS dim_dt_dob
ON per_fact.SourceBirthDateID = dim_dt_dob.DateID
LEFT OUTER JOIN CommunityMart.Dim.Date AS dim_dt_dod
ON per_fact.DeathDateID = dim_dt_dob.DateID
---- Referral Fact
--INNER JOIN CommunityMart.dbo.ReferralFact AS ref_fact
--ON per_fact.SourceSystemClientID = ref_fact.SourceSystemClientID
--	-- Referral Dates
--	LEFT OUTER JOIN CommunityMart.Dim.Date AS dim_dt_ref
--	ON ref_fact.ReferralDateID = dim_dt_ref.DateID
--	LEFT OUTER JOIN CommunityMart.Dim.Date AS dim_dt_dis
--	ON ref_fact.DischargeDateID = dim_dt_dis.DateID
--	-- Referral Dims
--	LEFT OUTER JOIN CommunityMart.Dim.ReferralPriority AS dim_ref_pri
--	ON ref_fact.ReferralPriorityID = dim_ref_pri.ReferralPriorityID
--	LEFT OUTER JOIN CommunityMart.Dim.ReferralReason AS dim_ref_reas
--	ON ref_fact.ReferralReasonID = dim_ref_reas.ReferralReasonID
--	LEFT OUTER JOIN CommunityMart.Dim.ReferralType AS dim_ref_type
--	ON ref_fact.ReferralTypeID = dim_ref_type.ReferralTypeID
--	LEFT OUTER JOIN CommunityMart.Dim.ReferralSourceLookup AS dim_ref_src_lkup
--	ON ref_fact.ReferralSourceLookupID = dim_ref_src_lkup.ReferralSourceLookupID
--		LEFT OUTER JOIN CommunityMart.Dim.ReferralSource AS dim_ref_src
--		ON dim_ref_src_lkup.ReferralSourceID = dim_ref_src.ReferralSourceID
--	-- Local Reporting Office
--	LEFT OUTER JOIN CommunityMart.Dim.LocalReportingOffice AS dim_lro
--	ON ref_fact.LocalReportingOfficeID = dim_lro.LocalReportingOfficeID
--		LEFT OUTER JOIN CommunityMart.Dim.CommunityLHA AS dim_clha
--		ON dim_lro.CommunityLHAID = dim_clha.CommunityLHAID
--		LEFT OUTER JOIN CommunityMart.Dim.CommunityProgram AS dim_prog
--		ON dim_lro.CommunityProgramID = dim_prog.CommunityProgramID
--	-- Assessment Fact
--	LEFT OUTER JOIN CommunityMart.dbo.AssessmentHeaderFact AS ass_fact
--	ON ref_fact.SourceReferralID = ass_fact.SourceReferralID
--		-- Assessment Dates
--		LEFT OUTER JOIN CommunityMart.Dim.Date AS dim_dt_ass_auth
--		ON ass_fact.AssessmentAuthorizedDateID = dim_dt_ass_auth.DateID
--		LEFT OUTER JOIN CommunityMart.Dim.Date AS dim_dt_ass_str
--		ON ass_fact.AssessmentDateID = dim_dt_ass_str.DateID
--		LEFT OUTER JOIN CommunityMart.Dim.Date AS dim_dt_ass_end
--		ON ass_fact.AssessmentEndDateID = dim_dt_ass_end.DateID
--		-- Assessment Dims
--		LEFT OUTER JOIN CommunityMart.Dim.AssessmentReason AS dim_ass_reas
--		ON ass_fact.AssessmentReasonID = dim_ass_reas.AssessmentReasonID
--		LEFT OUTER JOIN CommunityMart.Dim.AssessmentType AS dim_ass_type
--		ON ass_fact.AssessmentTypeID = dim_ass_type.AssessmentTypeID
--	-- Case Note Fact
--	LEFT OUTER JOIN CommunityMart.dbo.CaseNoteHeaderFact AS nte_fact
--	ON ref_fact.SourceReferralID = nte_fact.SourceReferralID
--		-- Case Note Date
--		LEFT OUTER JOIN CommunityMart.Dim.Date AS dim_dt_nte
--		ON nte_fact.CaseNoteDateID = dim_dt_nte.DateID
--		-- Case Note Dims
--		LEFT OUTER JOIN CommunityMart.Dim.CaseNoteReason AS dim_nte_reas
--		ON nte_fact.CaseNoteReasonID = dim_nte_reas.CaseNoteReasonID
--		LEFT OUTER JOIN CommunityMart.Dim.CaseNoteType AS dim_nte_type
--		ON nte_fact.CaseNoteTypeID = dim_nte_type.CaseNoteTypeID
--		-- Case Note Contact Fact
--		LEFT OUTER JOIN CommunityMart.dbo.CaseNoteContactFact AS cnt_fact
--		ON nte_fact.SourceCaseNoteHeaderID = cnt_fact.SourceCaseNoteHeaderID
--			-- Case Note Contact Dims
--			LEFT OUTER JOIN CommunityMart.Dim.ContactSetting AS dim_cnt_sett
--			ON cnt_fact.ContactSettingID = dim_cnt_sett.ContactSettingID
--			LEFT OUTER JOIN CommunityMart.Dim.ContactType AS dim_cnt_type
--			ON cnt_fact.ContactTypeID = dim_cnt_type.ContactTypeID
--	-- Intervention Fact
--	LEFT OUTER JOIN CommunityMart.dbo.InterventionFact AS int_fact
--	ON ref_fact.SourceReferralID = int_fact.SourceReferralID
--		-- Intervention Dates
--		LEFT OUTER JOIN CommunityMart.Dim.Date AS dim_dt_int_str
--		ON int_fact.OccurrenceStartDateID = dim_dt_int_str.DateID
--		LEFT OUTER JOIN CommunityMart.Dim.Date AS dim_dt_int_end
--		ON int_fact.OccurrenceEndDateID = dim_dt_int_end.DateID
--		-- Intervention Dims
--		LEFT OUTER JOIN CommunityMart.Dim.Intervention AS dim_int
--		ON int_fact.InterventionID = dim_int.InterventionID
--		LEFT OUTER JOIN CommunityMart.Dim.InterventionType AS dim_int_type
--		ON dim_int.InterventionTypeID = dim_int_type.InterventionTypeID
GROUP BY FLOOR(DATEDIFF(day, dim_dt_dob.ShortDate, dim_dt_dod.ShortDate)/365.25)
	,dim_gen.GenderDesc

