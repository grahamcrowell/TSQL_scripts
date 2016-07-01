--#region ${1:ShortNameofTest}
DECLARE @GUID guid;
SET @GUID = '${2:guid}'
SET @CreatedBy = 'gcrowell'
SET @UpdatedBy = 'gcrowell'
SELECT @BRID=BRID FROM dbo.DQMF_BizRule WHERE GUID=@GUID
 
SET @ActionSQL = '${1:}'

EXEC [dbo].[SetBizRule] 
@pBRId=@BRID, 
@pShortNameOfTest='${1:ShortNameofTest}', 
@pRuleDesc=@pShortNameOfTest, 
@pConditionSQL=${3:NULL}, 
@pActionID=${5:0}, 
@pActionSQL=@ActionSQL,
@pOlsonTypeID=${6:NULL}, 
@pSeverityTypeID=${7:NULL}, 
@pSequence=${8:0}, 
@pDefaultValue='${9:0}', 
@pDatabaseId='${10:32}', 
@pTargetObjectPhysicalName='${11:schema.table}', 
@pTargetAttributePhysicalName='${12:column}', 
@pSourceObjectPhysicalName=${13:NULL}, 
@pSourceAttributePhysicalName=${14:NULL}, 
@pIsActive=1, 
@pComment='', 
@pCreatedBy=@CreatedBy,
@pUpdatedBy=@UpdatedBy,
@pIsLogged=1, 
@pGUID=@GUID, 
@pFactTableObjectAttributeId=${15:NULL}

IF NOT EXISTS (SELECT * FROM dbo.DQMF_BizRuleSchedule bsc INNER JOIN dbo.DQMF_BizRule br ON bsc.BRID=br.BRID WHERE scheduleid= @DQMF_ScheduleId AND br.BRID=(SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID))
INSERT dbo.DQMF_BizRuleSchedule (BRID, ScheduleID) SELECT (SELECT BRID FROM DQMF_BizRule WHERE GUID=@GUID) AS BRID, @DQMF_ScheduleId 

DELETE BRM FROM dbo.DQMF_BizRuleLookupMapping BRM INNER JOIN dbo.DQMF_BizRule BR ON BRM.BRID = BR.BRID WHERE BR.GUID=@GUID
--#endregion ${1:ShortNameofTest}

${100:}