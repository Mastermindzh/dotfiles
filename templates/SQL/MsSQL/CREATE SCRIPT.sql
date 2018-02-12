/* Replace XDATABASE with the DB name */
USE MASTER
GO

-- Function will delete a database even when in use.
BEGIN TRY
	ALTER DATABASE XDATABASE SET SINGLE_USER WITH ROLLBACK IMMEDIATE
	DROP DATABASE XDATABASE
END TRY
BEGIN CATCH
	raiserror('XDATABASE doesn''t exist. Continuing....', 10, 1)
END CATCH;
GO

CREATE DATABASE XDATABASE
GO

USE XDATABASE
GO

-- -----------------------------------------------------
-- Table `Template`
-- -----------------------------------------------------
CREATE TABLE [Template] (
  [Column1] 		INT 		NOT NULL,
  [Column2] 		VARCHAR(30) NOT NULL,
  [Column3] 		VARCHAR(30) NOT NULL,
  CONSTRAINT pk_column1 PRIMARY KEY ([Column1]),
  CONSTRAINT ck_column2 CHECK 		([Column2] in ('M','V')),
  CONSTRAINT fk_column3 FOREIGN KEY ([Column3]) REFERENCES Patient([Patientnr])
)
GO
