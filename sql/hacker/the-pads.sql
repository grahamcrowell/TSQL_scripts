USE gcDev
GO

--https://www.hackerrank.com/challenges/the-pads

SELECT Name+'('+LEFT(Occupation, 1)+')'
FROM OCCUPATIONS
ORDER BY Name

SELECT 'There are total ' + CAST(COUNT(*) AS varchar) +' '+LOWER(Occupation)+'s'
FROM OCCUPATIONS
GROUP BY Occupation
ORDER BY COUNT(*)


