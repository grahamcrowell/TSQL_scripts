USE CommunityMart
GO

DECLARE @fact varchar(100);
DECLARE @dim1 varchar(100);
DECLARE @dim2 varchar(100);

SET @fact = 'ReferralFact'
SET @dim1 = 'LocalReportingOffice.ParisTeamName'
SET @dim2 = 'ReferralReason.ReferralReasonDesc'

DECLARE @format varchar(max) = '
;WITH tot AS (
	SELECT 1.*COUNT(*) AS tot
	FROM &(fact) 
), dim1 AS (
SELECT COUNT(*)/tot.tot AS per1, &(dim1)ID AS ID
FROM &(fact)
CROSS JOIN
tot
GROUP BY &(dim1)ID, tot.tot
), dim2 AS (
SELECT COUNT(*)/tot.tot AS per2, &(dim2)ID AS ID
FROM &(fact)
CROSS JOIN
tot
GROUP BY &(dim2)ID, tot.tot
), dim1and2 AS (
SELECT COUNT(*)/tot.tot AS perAND, &(dim1)ID AS ID1, &(dim2)ID AS ID2
FROM &(fact)
CROSS JOIN
tot
GROUP BY &(dim1)ID, &(dim2)ID, tot.tot
), calcs AS (
SELECT log(per1*per2) AS [log P(A)*P(B)], log(perAND) AS [log P(A and B)], log(per1*per2)-log(perAND) AS [log P(A)*P(B) - log P(A and B)], dim1and2.ID1, dim1and2.ID2
FROM dim1
CROSS JOIN
dim2
INNER JOIN dim1and2
ON dim1.ID = dim1and2.ID1
AND dim2.ID = dim1and2.ID2
)
SELECT calcs.*, dim1.&(desc1), dim2.&(desc2)
FROM calcs
JOIN Dim.&(dim1) AS dim1
ON dim1.&(dim1)ID = calcs.ID1
JOIN Dim.&(dim2) AS dim2
ON dim2.&(dim2)ID = calcs.ID2
ORDER BY abs([log P(A)*P(B) - log P(A and B)]) DESC
'

SET @format = REPLACE(@format,'&(desc1)',PARSENAME(@dim1,1))
SET @format = REPLACE(@format,'&(desc2)',PARSENAME(@dim2,1))
SET @format = REPLACE(@format,'&(dim1)',PARSENAME(@dim1,2))
SET @format = REPLACE(@format,'&(dim2)',PARSENAME(@dim2,2))
SET @format = REPLACE(@format,'&(fact)',PARSENAME(@fact,1))

PRINT @format
EXEC(@format)