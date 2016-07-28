USE CommunityMart
GO

SElect Distinct object_name(part.object_id), SUM(rows)
fROM sys.partitions AS part
where OBJECT_SCHEMA_NAME(part.object_id) = 'dbo'
group by part.index_id,object_name(part.object_id)



SELECT *
FROM sys.dm_db_stats_properties (object_id('ReferralFact'), 2) as ddsp

SELECT COUNT(*)
FROM ReferralFact;

DBCC SHOW_STATISTICS('ReferralFact','ReferralReasonID') WITH HISTOGRAM

exec sp_MSforeachtable
@command1=N'SELECT * FROM sys.dm_db_stats_properties (object_id(''?''), 2) as ddsp'
