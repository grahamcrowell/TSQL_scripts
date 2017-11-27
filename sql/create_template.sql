--#region CREATE DATABASE
USE master
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = '<dst_database_name,,>';
SET @sql = FORMATMESSAGE('CREATE DATABASE %s;', @name);

IF DB_ID(@name) IS NULL
BEGIN
	IF EXISTS(SELECT * FROM sys.master_files WHERE name = @name)
	BEGIN
        RAISERROR('ERROR: database file %s already exists', 11, 1, @name) WITH NOWAIT;
		SELECT DB_NAME(database_id) AS database_name, * FROM sys.master_files WHERE name = @name
	END
	ELSE
	BEGIN
		RAISERROR(@sql, 0, 10) WITH NOWAIT;
        EXEC(@sql);
	END
END
GO
--#endregion CREATE DATABASE

--#region CREATE SCHEMA
USE <dst_database_name,,>
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = '<dst_object_name,,>';
SET @sql = FORMATMESSAGE('CREATE SCHEMA %s;',@name);

IF SCHEMA_ID(@name) IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END
GO
--#endregion CREATE SCHEMA

--#region CREATE TABLE
USE <dst_database_name,,>
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = '<dst_object_name,,>';
SET @sql = FORMATMESSAGE('DROP TABLE %s;',@name);

IF OBJECT_ID(@name,'U') IS NOT NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END

CREATE TABLE <dst_object_name,,>
(
	<table_definition,,>
);
GO
--#endregion CREATE TABLE

--#region CREATE/ALTER VIEW
USE <dst_database_name,,>
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = '<dst_object_name,,>';
SET @sql = FORMATMESSAGE('CREATE VIEW %s AS SELECT 1 AS [one];',@name);

IF OBJECT_ID(@name,'V') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END

ALTER VIEW <dst_object_name,,>
AS
	<query_definition,,>
;
GO
--#endregion CREATE/ALTER VIEW

--#region CREATE/ALTER PROC
USE <dst_database_name,,>
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = '<dst_object_name,,>';
SET @sql = FORMATMESSAGE('CREATE PROC %s AS BEGIN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'P') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END

ALTER PROC <dst_object_name,,>
AS
	<sql_definition,,>
;
GO
--#endregion CREATE/ALTER PROC
WHERE obj.type IN ('FN', 'TF')
--#region CREATE/ALTER TABLE FUNC
USE <dst_database_name,,>
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = '<dst_object_name,,>';
SET @sql = FORMATMESSAGE('CREATE FUNC %s() RETURNS TABLE AS BEGIN RETURN SELECT 1 AS [one] END;',@name);

IF OBJECT_ID(@name,'IF') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END

ALTER FUNCTION <dst_object_name,,>
AS
	<function_definition,,>
;
GO
--#endregion CREATE/ALTER TABLE FUNC

--#region CREATE/ALTER SCALAR FUNC
USE <dst_database_name,,>
GO

DECLARE @name nvarchar(max);
DECLARE @sql nvarchar(max);

SET @name = '<dst_object_name,,>';
SET @sql = FORMATMESSAGE('CREATE FUNC %s() RETURNS int AS BEGIN DECLARE @ret int = 1; RETURN @ret END;',@name);

IF OBJECT_ID(@name,'FN') IS NULL
BEGIN
	RAISERROR(@sql, 0, 0) WITH NOWAIT;
	EXEC(@sql);
END

ALTER FUNCTION <dst_object_name,,>
AS
	<function_definition,,>
;
GO
--#endregion CREATE/ALTER SCALAR FUNC

