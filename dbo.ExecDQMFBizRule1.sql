USE [DSDW]
GO
/****** Object:  StoredProcedure [dbo].[ExecDQMFBizRule]    Script Date: 6/9/2016 12:11:15 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/* =============================================
 Author:                    <Author Name>
 Create date:               <Create Date>
 Description:               <Description>
 Change History:
<Date>                  <Alias>                <Desc>
27-Nov-2009             DR408                  Added ETLBizRuleAuditFact.PkgExecID
24-Jun-2010             DR791                  Add logic to allow conditional SQL on Lookup BR's if exists
29-Jun-2010             DR791                  Remove hard coded table alias on join conditions for ActionID=0
                                               section.  Business Rule will need to specify appropriate alias
                                               when defining join condition.
30-Jun-2010             DR791                  Update ActionID=0 section when logging in Audit table, include ActionID
07-Jul-2010             DR791                  Add table alias and remove table name from UPDATE statment to allow
                                               same table to be updated. Line 324.
08-Jul-2010             DR791                  For conditional SQL process, add check for empty string along with null
21-Jul-2010             DR856                  Implement ActionID 4, conditional logging of rules
04 Aug 2010             DR883                  Add ORDER BY clause to cursor c_2 to ensure that previous value source 
                                               is returned last - and so used in the Log statement.
											   Change ActionSQL outside of any other SQL.
aug 30 2010				DR918 		            PackageExecKey logging removal  -  grants
Sep 22 2010             DR911                  Add IsLogged logic to ActionID=0 processing (previously only in >0)
Oct 25 2012				DR2289				   Update logic so that by default ISForDQ is 1 - Alan
Oct 26 2015				DR7226				   Update logic to include Type 5 rules.  These should be used for testing\validation - Alan
Jan 26 2016             DR7318                 add BusinessKey field logic . DG
Mar 1  2016             DR7318                 add logic for ID=0 lookup constraint

NOTE: ActionID=0 processing:
      Table alias: source & target staging table could be the same if code and ID columns defined or can
      be different if source contains data load only and transitions to an intermediate table with IDs
      that simulate the end result fact table.
      Business rules for conditionalSQL may need to include the appropriate alias as part of the rule.

      ActionID=4 processing
      Substitute ACTIONSQL for the WhileClause TSQL block
      Log the execution in dbo.AuditBizRuleAction4Execution

dbo.DQMF_BizRule:
      F = staging target fact table to update, defined in business rule as TargetObjectPhysicalName
      S = staging source fact table passed as parameter to procedure

dbo.DQMF_BizRuleLookupMapping:
      SourceLookupExpression should have prefix S. on column value
      DimensionLookupExpression should have prefix D. on column value

 =============================================*/
CREATE PROCEDURE [dbo].[ExecDQMFBizRule]
        @pStageName varchar(100),
    @pExtractFileKey bigint,
    @pActionId int = NULL,
    @pSourceTable sysname = NULL,
    @pBRId int = NULL,
    @Debug int = 0
AS

SET NOCOUNT ON

DECLARE @CondSQLStr varchar(max),
        @ScheduleID int,
        @SQLSTR varchar(max),
        @NewValue varchar(max),
        @PreviousValue varchar(100),
        @TableId varchar(10),
        @DatabaseId varchar(10),
        @Table varchar(100),
        @BRID varchar(10),
        @actionID varchar(5),
        @AttributeId varchar(5),
        @OlsonTypeID varchar(5),
        @SeverityTypeID varchar(5),
        @NegativeRating  varchar(5),
        @PkgExecID bigint

DECLARE @DefaultValue varchar(100),
        @FactTable sysname,
        @DimensionTable sysname,
        @SourceLookupTerm nvarchar(1000),
        @DimensionLookupTerm nvarchar(1000),
        @JoinCount int,
        @FactForeignKey sysname,
        @DimensionKey sysname,
        @stmt nvarchar(max),
        @Rowcount int,
        @TotalRowcount int,
        @Error int,
        @WhileClause varchar(max),
        @Message varchar(1000),
        @ErrorMessage varchar(1000),
		@ActionSQL varchar(max),
		@IsLogged bit,
		@BusinessKeyExpr varchar(500)

IF @Debug > 0 RAISERROR( '-- ExecDQMFBizRule: Calling GetDQMFScheduleID...', 0, 1 ) WITH NOWAIT
EXEC DQMF.dbo.GetDQMFScheduleID
    @pStageName =  @pStageName,
    @pScheduleID = @ScheduleID output

IF @Debug > 0 RAISERROR( '-- ExecDQMFBizRule: Calling GetPkgExecID...', 0, 1 ) WITH NOWAIT
-- get the PkgExecID from the AuditExtractFile table
EXEC DQMF.dbo.GetPkgExecID
    @pExtractFileID =  @pExtractFileKey,
    @pPkgExecID = @PkgExecID output

	SELECT @PkgExecID = isnull(@PkgExecID,0)  -- set @PkgExecID to zero if it is null

--IF @pActionId IS NULL
--BEGIN

    SELECT br.*
    INTO #BizRule
    FROM DQMF.dbo.DQMF_BizRule br
        INNER JOIN DQMF.dbo.DQMF_BizRuleSchedule brs
            ON br.BRID = brs.BRID
    WHERE ScheduleId = @ScheduleID 
 AND ActionID >0   AND ActionID <> 3  AND  IsActive = 1
    ORDER BY Sequence

    WHILE (SELECT count(*) FROM #BizRule) > 0
    BEGIN
         SELECT @CondSQLStr = ConditionSQL,
                @NewValue = defaultValue,
                @PreviousValue = TargetObjectAttributePhysicalName,
                @TableId = 0,
                @DatabaseId = DatabaseId,
                @Table = TargetObjectPhysicalName,
                @BRID = BRId,
                @actionID = ActionID,
                @AttributeId = 0,
                @OlsonTypeID = OlsonTypeID,
                @SeverityTypeID = SeverityTypeID,
				@ActionSQL = ActionSQL,
				@IsLogged = IsLogged,
				@BusinessKeyExpr = BusinessKeyExpression
        FROM #BizRule
        WHERE BRId in (SELECT TOP 1 BRId
                        FROM #BizRule
                       ORDER BY Sequence )

		INSERT DQMF.dbo.AuditBizRuleExecution
		SELECT @BRID, getdate(), @pExtractFileKey
			

        IF @Debug > 2
            SELECT @CondSQLStr CondSQLStr,
                @NewValue NewValue,
                @PreviousValue PreviousValue,
                @TableId TableId,
                @DatabaseId DatabaseId,
                @Table Tablex,
                @BRID BRID,
                @actionID actionID,
                @AttributeId AttributeId,
                @OlsonTypeID OlsonTypeID,
                @SeverityTypeID  SeverityTypeID,
				@ActionSQL ActionSQL,
				@IsLogged IsLogged,
				@BusinessKeyExpr BusinessKeyExpression

        IF @Debug > 0 RAISERROR( '--ExecDQMFBizRule: @BRID = %s.', 0, 1, @BRID ) WITH NOWAIT

		IF (@ActionID in (4,5))
			BEGIN
				if @ActionID = 4 
				Begin
      				IF (ISNULL(@ActionSQL,'') = '')
      						SET @SQLSTR = ' '
      				ELSE
      					SET @SQLSTR = @ActionSQL 
				End 
				Else
					--SET @SQLSTR = 'Insert into dsdw.Validation.BizRuleOutput 
					--Select ' + @BRID + ' as BRID,count(*),getdate() from
					--(' + @ActionSQL + ') tmp'

					SET @SQLSTR = 'Insert into DQMF.dbo.ETLBizRuleAuditFact 
					(DQMF_ScheduleId,PkgExecKey,brid, PreviousValue,OlsonTypeID,DatebaseID,
						tableid,attributeid,severitytypeid,ActionID)
					Select DQMF_ScheduleId = '+ ISNULL(convert(varchar(10),@ScheduleID),'') + ',
							PkgExecKey = '+ convert(varchar(10),isnull(@PkgExecID,0)) + ',
							BRID =' + @BRID + ',
							PreviousValue = convert(varchar(15),isnull(count(*),0)),
							OlsonTypeID = ' + ISNULL(@OlsonTypeID,0) + ',
							DatebaseID = '+ ISNULL(@DatabaseId,'null') + ',
							tableid = ''' + ISNULL(@TableId,'null') + ''',
							attributeid = '+ ISNULL(@AttributeId,'null') +',
							severitytypeid = ' + ISNULL(@SeverityTypeID,'null') +',
							ActionID = 5 
							from (' + @ActionSQL + ') tmp'
					

      			INSERT DQMF.dbo.AuditBizRuleAction4Execution
      			SELECT @BRID, @pExtractFileKey,@ActionSQL

			END
		ELSE
			BEGIN
			SET @SQLSTR = ' CREATE TABLE #result (ETLAuditID bigint NOT NULL)
                       insert #result
                       ' + @CondSQLStr + '
                       IF (select count(*) from #result) >= 1
						   BEGIN
                                SELECT *
								INTO #ActionTemp
								FROM ' + @Table + '
								WHERE ETLAuditID in (SELECT ETLAuditID FROM #result)


								 

								' + CASE @IsLogged WHEN 1 THEN '
									 INSERT DQMF.dbo.ETLBizRuleAuditFact (ETLId, PkgExecKey,
																		   DQMF_ScheduleId,BRId,DatebaseId,
																		   TableId,AttributeId,PreviousValue,NewValue,
																		   OlsonTypeID,ActionID,SeverityTypeID,NegativeRating,ISCorrected,ISForDQ, BusinessKey)
									 SELECT  ETLAuditID,
											   '+ convert(varchar(10),@PkgExecID) + ',
											   '+ convert(varchar(10),@ScheduleID) + ',
											   ' + @BRID +',
											   '+ @DatabaseId + ',
											   '+ @TableId+ ',
											   '+ @AttributeId +',
												'+ @PreviousValue +' ,
												'+ @NewValue +',
												' + ISNULL(@OlsonTypeID,'null') +',
												' + @ActionID + ',
												' + ISNULL(@SeverityTypeID,'null') +',
												null,0,1, '+
												isnull(@BusinessKeyExpr,'null') + ' 
												 from #ActionTemp
									' ELSE ' ' END + '
								 IF (' + @ActionID + ' = 2 )
								 BEGIN
									 update ' + @Table + ' 
									  set ' +@PreviousValue +' = '+ ISNull(@NewValue,0) +'
									  where ETLAuditID in (SELECT ETLAuditID FROM #ActionTemp)
								 END
								END '
			END --ActionID<>4


        IF @Debug > 1 BEGIN PRINT @SQLSTR RAISERROR( '', 0, 1 ) WITH NOWAIT END

        exec (@SQLSTR)
        SELECT @Rowcount = @@ROWCOUNT, @Error = @@ERROR
        IF @Error <> 0 BEGIN PRINT @stmt RETURN END

        DELETE FROM #BizRule
        WHERE BRId in (SELECT top 1 BRId FROM #BizRule ORDER BY Sequence)
        SET @SQLSTR = ''
    END

    DROP TABLE #BizRule
--END

IF @pActionId = 0
BEGIN

    BEGIN TRY

        DECLARE c_1 CURSOR FAST_FORWARD LOCAL FOR
        SELECT BR.BRId, BR.SourceObjectPhysicalName, BR.SourceAttributePhysicalName, BR.TargetObjectPhysicalName,
               BR.TargetObjectAttributePhysicalName, BR.DefaultValue, BR.ConditionSQL -- **dc add ConditionalSQL
				,br.islogged
				,br.BusinessKeyExpression
        FROM DQMF.dbo.DQMF_BizRuleSchedule BRS
            JOIN DQMF.dbo.DQMF_BizRule BR
                ON BR.BRId = BRS.BRId
                AND BR.IsActive = 1 and ACtionID = 0
        WHERE BRS.ScheduleId = @ScheduleId
        AND ( @pBRId IS NULL OR BR.BRId = @pBRId )
        ORDER BY IsNull( BR.Sequence, 999999 ), BR.BRId

        OPEN c_1

        FETCH NEXT FROM c_1 INTO @BRId, @DimensionTable, @DimensionKey, @FactTable, @FactForeignKey, @DefaultValue, @CondSQLStr-- **dc add @CondSQLStr
								,@IsLogged,@BusinessKeyExpr
        WHILE @@FETCH_STATUS <> -1
        BEGIN



        SET @Message = '--Processing table ' + @pSourceTable + ' ' + Cast( @BRId AS varchar )

        IF @Debug > 0 RAISERROR( '%s', 0, 1, @Message ) WITH NOWAIT

              		INSERT DQMF.dbo.AuditBizRuleExecution  SELECT @BRID, getdate(), @pExtractFileKey   --log teh rule execution

            SET @Message = '--Update fact with dimension key ' + @FactForeignKey + ' (BR ' + Cast( @BRId AS varchar ) + ')...'
            IF @Debug > 0 RAISERROR( '    %s', 0, 1, @Message ) WITH NOWAIT

            -- Perform the lookups
            SET @stmt = 'UPDATE F SET
                ' + @FactForeignKey + ' = D.' + @DimensionKey + '
            FROM ' + @FactTable + ' F
                JOIN ' + @pSourceTable + ' S
                    ON S.ETLAuditId = F.ETLAuditId
                JOIN ' + @DimensionTable + ' D'

            -- Build the ON clause of the dimension table join
            SET @JoinCount = 1
            DECLARE c_2 CURSOR LOCAL FOR
            SELECT SourceLookupExpression, DimensionLookupExpression
            FROM DQMF.dbo.DQMF_BizRuleLookupMapping
            WHERE BRId = @BRId
			ORDER BY IsSourcePreviousValue asc

            OPEN c_2
            FETCH NEXT FROM c_2 INTO @SourceLookupTerm, @DimensionLookupTerm
            WHILE @@FETCH_STATUS <> -1
            BEGIN
                SET @stmt = @stmt + nchar(13) + nchar(10) + '            ' + CASE WHEN @JoinCount = 1 THEN 'ON ' ELSE 'AND ' END +
                    @DimensionLookupTerm + ' = ' + @SourceLookupTerm
                FETCH NEXT FROM c_2 INTO @SourceLookupTerm, @DimensionLookupTerm
                SET @JoinCount = @JoinCount + 1
            END

            CLOSE c_2
            DEALLOCATE c_2

 --           -- **dc conditionally add WHERE clause to filter lookup list
 --               IF (IsNull(@CondSQLStr,'') <> '' )
 ----               IF (@CondSQLStr IS NOT NULL)
 --               SET @stmt = @stmt +  nchar(13) + nchar(10) + '            ' + N' WHERE ' + @CondSQLStr

			--**********************

			 --Lien Exclude ID 0 from @DimensionTable
				  IF RIGHT(@DimensionKey,2) = 'ID'
						SET @stmt = @stmt +  nchar(13) + nchar(10) + '            ' + N' WHERE D.' + @DimensionKey + ' <> 0' 
				  ELSE
						SET @stmt = @stmt +  nchar(13) + nchar(10) + '            ' + N' WHERE 1 = 1'
                              
			-- **dc conditionally add WHERE clause to filter lookup list
				  IF (IsNull(@CondSQLStr,'') <> '' )
			--               IF (@CondSQLStr IS NOT NULL)
					  SET @stmt = @stmt +  nchar(13) + nchar(10) + '            ' + N' AND (' + @CondSQLStr +')'


			--**********************

            IF @Debug > 1 BEGIN PRINT @stmt RAISERROR( ' ', 0, 1 ) WITH NOWAIT END

            EXEC sp_executesql @stmt = @stmt

            SELECT @Rowcount = @@ROWCOUNT, @Error = @@ERROR
            SET @Message = '-- ' + Cast( @Rowcount AS varchar ) + '-- Lookups found.'
            IF @Debug > 0 RAISERROR( '    %s', 0, 1, @Message ) WITH NOWAIT
            BEGIN

				IF @IsLogged = 1 
				BEGIN
					SET @Message = '--Logging the lookup failures...'
					IF @Debug > 0 RAISERROR( '    %s', 0, 1, @Message ) WITH NOWAIT

					-- Log the rule failures
					SET @stmt = 'INSERT INTO DQMF.dbo.ETLBizRuleAuditFact( PkgExecKey, DQMF_ScheduleId, ETLId, BRId, ActionID, PreviousValue, NewValue,ISForDQ, BusinessKey )
					SELECT '+ convert(varchar(20),@PkgExecID) + ', @ScheduleID, S.ETLAuditId, @BRId, 0, Left( ' + @SourceLookupTerm + ', 50 ) AS PreviousValue, @DefaultValue AS NewValue,1, ' +
					         ISNULL(@BusinessKeyExpr,'null') + '
					FROM ' + @FactTable + ' F
						JOIN ' + @pSourceTable + ' S
							ON S.ETLAuditId = F.ETLAuditId
					WHERE F.' + @FactForeignKey + ' IS NULL'

					-- **dc conditionally add WHERE clause to filter lookup list
					IF (IsNull(@CondSQLStr,'') <> '' )
						SET @stmt = @stmt +  nchar(13) + nchar(10) + '            ' + N' AND ' + @CondSQLStr

					IF @Debug > 1 BEGIN PRINT @stmt RAISERROR( ' ', 0, 1 ) WITH NOWAIT END

					EXEC sp_executesql @stmt = @stmt,
						@params = N'@PkgExecKey int, @ScheduleID int, @BRId int, @DefaultValue varchar(50)',
						@PkgExecKey = @PkgExecID, @ScheduleID = @ScheduleID, @BRId = @BRId, @DefaultValue = @DefaultValue

					SELECT @Rowcount = @@ROWCOUNT
					SET @Message = '-- ' + Cast( @Rowcount AS varchar ) + ' Lookup failures logged.'
					IF @Debug > 0 RAISERROR( '    %s', 0, 1, @Message ) WITH NOWAIT
				END

                SET @Message = '--Setting the default values...'
                IF @Debug > 0 RAISERROR( '    %s', 0, 1, @Message ) WITH NOWAIT

                -- Set the default values
                -- **dc add FROM/JOIN/ON clause to alias source table if business rule requires for filtering
--                SET @stmt = 'UPDATE ' + @FactTable
                SET @stmt = 'UPDATE F '  -- dc 7-Jul-2010
                  + ' SET ' + @FactForeignKey + ' = @DefaultValue
                FROM ' + @FactTable + ' F
                    JOIN ' + @pSourceTable + ' S
                        ON S.ETLAuditId = F.ETLAuditId
                WHERE F.' + @FactForeignKey + ' IS NULL'

                -- **dc conditionally add WHERE clause to filter lookup list
                IF (IsNull(@CondSQLStr,'') <> '' )
 --               IF (@CondSQLStr IS NOT NULL)
                    SET @stmt = @stmt +  nchar(13) + nchar(10) + '            ' + N' AND ' + @CondSQLStr


                IF @Debug > 1 BEGIN PRINT @stmt RAISERROR( ' ', 0, 1 ) WITH NOWAIT END

                EXEC sp_executesql @stmt = @stmt, @params = N'@DefaultValue varchar(50)', @DefaultValue = @DefaultValue

                SELECT @Rowcount = @@ROWCOUNT
                SET @Message = '-- ' + Cast( @Rowcount AS varchar ) + ' Failed lookup defaults set.'
                IF @Debug > 0 RAISERROR( '    %s', 0, 1, @Message ) WITH NOWAIT

            END

            FETCH NEXT FROM c_1 INTO @BRId, @DimensionTable, @DimensionKey, @FactTable, @FactForeignKey, @DefaultValue, @CondSQLStr-- **dc add @CondSQLStr
								,@IsLogged,@BusinessKeyExpr
        END

        CLOSE c_1
        DEALLOCATE c_1

        IF @Debug > 0 RAISERROR( '--Done.', 0, 1 ) WITH NOWAIT
    END TRY
    BEGIN CATCH

        SET @ErrorMessage = ERROR_MESSAGE()

        PRINT ''
        RAISERROR( 'ExecDQMFBizRule: Error occurred at step: %s, Error Message: %s.', 16, 1, @Message, @ErrorMessage )

        RETURN 1

    END CATCH

END

--exec [ExecDQMFBizRule] 
--    @pStageName = 'Daily Data Mart table ED rules',
--    @pActionId = 0,
--    @pSourceTable = 'Staging.ED_Visit',
--    @pExtractFileKey = 179238,@debug = 3' 

GO
