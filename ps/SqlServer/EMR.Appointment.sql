--USE CommunityMart
--GO

IF EXISTS(SELECT 1 FROM sys.objects WHERE OBJECT_ID = OBJECT_ID(N'EMR.Appointment') AND type = (N'U'))   
 DROP TABLE EMR.Appointment
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO

-- columns not available in first release: (due to Find Objects query tool in EMR)
-- CaseID, ApptStatusCode

CREATE TABLE EMR.Appointment
( 
	EMRID                   varchar(20)  NULL,
	ParisID                 varchar(8)   NULL,
	CaseID                  varchar(20)  NULL,
	ApptID                  varchar(20)  NULL,
	GroupID                 varchar(20)  NULL,
	ApptPOS                 varchar(50)  NULL,
	ApptPOSDesc             varchar(100) NULL,
	ApptTypeCode            varchar(50)  NULL,
	ApptTypeDesc            varchar(100) NULL,
	ApptReasonCode          varchar(50)  NULL,
	ApptReasonDesc          varchar(100) NULL,
	ApptBookedDate          varchar(20)  NULL,-- yyyymmdd
	ApptBookedTime          varchar(20)  NULL,
	ApptArrivalDate         varchar(20)  NULL,-- yyyymmdd
	ApptArrivalTime         varchar(20)  NULL,
	ApptSeenDate            varchar(20)  NULL,-- yyyymmdd
	ApptSeenTime            varchar(20)  NULL,
	ApptClosedDate          varchar(20)  NULL,-- yyyymmdd, not available with first release
	ApptClosedTime          varchar(20)  NULL,-- not available with first release
	ApptStatus              varchar(50)  NULL,
	ApptProvCode            varchar(50)  NULL,
	ApptProvName            varchar(100) NULL,
	ApptProvSpecialityCode  varchar(50)  NULL,
	ApptProvSpecialityDesc  varchar(100) NULL,
	ApptProvStatus          varchar(50)  NULL,
	IsCancelled             varchar(5)   NULL,
	IsConfirmed             varchar(5)   NULL,
	IsNoShow                varchar(5)   NULL,
	IsNoShowFlag            varchar(5)   NULL,
    SourceSystemLastUpdated varchar(20)  NULL,
    CreateDate              datetime     NULL
)

GO
SET ANSI_PADDING OFF

