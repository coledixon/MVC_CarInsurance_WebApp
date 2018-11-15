/* SCHEMA FOR C# MVC WEB APPLICATION */
/* Copyright 2018 || Cole Dixon || All rights reserved */

IF NOT EXISTS(SELECT name FROM sys.databases WHERE name ='db_insurance')
BEGIN
	CREATE DATABASE [db_insurance]
END
GO

USE [db_insurance]
GO


/* --- TABLES --- */

IF OBJECT_ID('dbo.insuree_main') is null
BEGIN
	-- master insuree table
	CREATE TABLE insuree_main (
			[insuree_key] int IDENTITY(1,1),
			[first_name] varchar(50) not null,
			[last_name] varchar(50) not null,
			[create_date] datetime not null,
			[upd_date] datetime null,
		PRIMARY KEY NONCLUSTERED 
		(
			[insuree_key] ASC
		) ON [PRIMARY]
	)

		ALTER TABLE insuree_main
			ADD CONSTRAINT def_createDate DEFAULT (GETDATE()) FOR [create_date]
END

GO

IF OBJECT_ID('dbo.insuree_info') is null
BEGIN
	-- insuree info
	CREATE TABLE insuree_info (
			[insuree_key] int not null,
			[email] varchar(200) not null,
			[dob] datetime not null,
			[state] varchar(2) not null,
			[zip] int not null,
		CONSTRAINT fk_addressContact FOREIGN KEY (insuree_key) REFERENCES insuree_main(insuree_key)
	)

		CREATE UNIQUE NONCLUSTERED INDEX natKey_insureeInfo ON insuree_info (
			[insuree_key]
		)
END

GO


IF OBJECT_ID('dbo.car_main') is null
BEGIN
	-- master car table
	CREATE TABLE car_main (
			[insuree_key] int not null,
			[car_year] int not null,
			[car_make] varchar(50) not null,
			[car_model] varchar(50) not null,
		CONSTRAINT fk_carMain FOREIGN KEY (insuree_key) REFERENCES insuree_main(insuree_key)
	)

		CREATE UNIQUE NONCLUSTERED INDEX natKey_carMain ON car_main (
			[insuree_key]
		)
END

GO

IF OBJECT_ID('dbo.insuree_quote') is null
BEGIN
	-- associated quote
	CREATE TABLE insuree_quote (
			[insuree_key] int not null,
			[coverage_type] varchar(12) not null,
			[curr_quote] varchar(10) null,
			[prev_quote] varchar(10) null,
		CONSTRAINT fk_insureeQuote FOREIGN KEY (insuree_key) REFERENCES insuree_main(insuree_key)
	)

		CREATE UNIQUE NONCLUSTERED INDEX natKey_insureeQuote ON insuree_quote (
			[insuree_key]
		)
END

GO

IF OBJECT_ID('dbo.insuree_hist') is null
BEGIN
	-- driver history
	CREATE TABLE insuree_hist (
			[insuree_key] int not null,
			[dui] int null,
			[tickets] int null,
		CONSTRAINT fk_insureeHist FOREIGN KEY (insuree_key) REFERENCES insuree_main(insuree_key)
	)

		CREATE UNIQUE NONCLUSTERED INDEX natKey_insureeHist ON insuree_hist (
			[insuree_key]
		)
END

GO