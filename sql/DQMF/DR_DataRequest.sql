USE DataRequest
GO

DECLARE @waldo varchar(max) = 'location'

SELECT 
	dr.RequestDate
	,stat.status
	,dr.IDNumber
	,dr.RequestTitle
	,dr.Description
	,dr.Notes
	,dev_emp.Empfname AS Dev
	,test_emp.Empfname AS Test
FROM DataRequest.dbo.DataRequest AS dr
JOIN DataRequest.dbo.Requestor AS req
ON dr.RequestorID = req.RequestorID
LEFT JOIN DataRequest.dbo.Employee AS ass_to_emp
ON dr.AssignToEMP = ass_to_emp.EMPID
JOIN DataRequest.dbo.Employee AS rec_by_emp
ON dr.RecievedByEmp = rec_by_emp.EMPID
LEFT JOIN DataRequest.dbo.Employee AS ass_by_emp
ON dr.AssignbyEMP = ass_by_emp.EMPID
LEFT JOIN DataRequest.dbo.Employee AS dev_emp
ON dr.DeveloperEMPID = dev_emp.EMPID
LEFT JOIN DataRequest.dbo.Employee AS test_emp
ON dr.TesterEMPID = test_emp.EMPID
LEFT JOIN DataRequest.dbo.Status AS stat
ON dr.StatusID = stat.StatusID
WHERE 1=1
--AND (
--	dr.RequestTitle LIKE '%'+@waldo+'%' OR
--	dr.Description LIKE '%'+@waldo+'%' OR
--	dr.Notes LIKE '%'+@waldo+'%'
--)
AND dev_emp.Empfname LIKE 'graham'
ORDER BY dr.RequestDate DESC