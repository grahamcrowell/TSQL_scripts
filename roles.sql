
SELECT
	db_prin_role.name AS DatabaseRoleName,
	ISNULL(db_prin_user.name, 'No members') AS DatabaseUserName
FROM sys.database_principals AS db_prin_role
LEFT JOIN sys.database_role_members AS db_role
ON db_role.role_principal_id = db_prin_role.principal_id
LEFT JOIN sys.database_principals AS db_prin_user
ON db_prin_user.principal_id = db_role.member_principal_id
WHERE db_prin_role.type = 'R'
ORDER BY db_prin_role.name;

SELECT db_prin_user.
FROM sys.database_role_members AS db_role
LEFT JOIN sys.database_principals AS db_prin_user
ON db_prin_user.principal_id = db_role.member_principal_id
WHERE db_prin_user.type = 'R'