/* Replace XDATABASE with the DB name */
USE XDATABASE
GO
-- SET LANGUAGE DUTCH /* ONLY USE WHEN WORKING WITH DUTCH DATES*/
GO
-- -----------------------------------------------------
-- Table `Template`
-- -----------------------------------------------------
INSERT INTO [Template] 
([Column1]	, [Column2]		,[Column3]		,[Geboortedatum]) VALUES 
('1'		, 'A'			, 'a'			, '03-02-1957'),
('2'		, 'B'			, 'a'			, '22-08-1957')
GO

-- SET LANGUAGE ENGLISH
