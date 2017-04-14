USE gcDev
GO

SELECT [Doctor], [Professor], [Singer], [Actor]
FROM (
    SELECT Name, Occupation, ROW_NUMBER() OVER(PARTITION BY Occupation ORDER BY Name) AS rn
    FROM OCCUPATIONS
) AS src
PIVOT
(
    MAX(Name)
    FOR Occupation IN ([Doctor], [Actor], [Professor], [Singer])
) AS pvt