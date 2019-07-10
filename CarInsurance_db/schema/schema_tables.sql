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
-- each table reqs primary key for Entity Framework

-- CD REMOVED: Entity handles login (cannot find way to override this)
--IF OBJECT_ID('dbo.login_main') is null
--BEGIN
--	--master login table
--	CREATE TABLE login_main (
--			[login_user_key] int IDENTITY(1,1),
--			[username] varchar(25) not null,
--			[password] varchar(10) not null
--		PRIMARY KEY NONCLUSTERED
--		(
--			[login_user_key]
--		) ON [PRIMARY]
--	)
--END

--GO

IF OBJECT_ID('dbo.insuree_main') is null
BEGIN
	-- master insuree table
	CREATE TABLE insuree_main (
			[insuree_key] int IDENTITY(1,1),
			[login_user_key] int not null,
			[first_name] varchar(50) not null,
			[last_name] varchar(50) not null,
			[create_date] datetime not null,
			[upd_date] datetime null,
		PRIMARY KEY NONCLUSTERED 
		(
			[insuree_key] ASC
		) ON [PRIMARY],

		CONSTRAINT fk_loginUserKey FOREIGN KEY (login_user_key) REFERENCES login_main(login_user_key)
	)

		ALTER TABLE insuree_main
			ADD CONSTRAINT def_createDate DEFAULT (GETDATE()) FOR [create_date]
END

GO

IF OBJECT_ID('dbo.insuree_info') is null
BEGIN
	-- insuree info
	CREATE TABLE insuree_info (
			[info_key] int IDENTITY(1,1),
			[insuree_key] int not null,
			[email] varchar(200) not null,
			[dob] datetime not null,
			[state] varchar(2) not null,
			[zip] int not null,
		PRIMARY KEY NONCLUSTERED
		(
			[info_key] ASC
		) ON [PRIMARY],

		CONSTRAINT fk_addressContact FOREIGN KEY (insuree_key) REFERENCES insuree_main(insuree_key)
	)

		CREATE UNIQUE NONCLUSTERED INDEX natKey_insureeInfo ON insuree_info (
			[insuree_key]
		)
END

GO

IF OBJECT_ID('dbo.insuree_car') is null
BEGIN
	-- insuree car info
	CREATE TABLE insuree_car (
			[insuree_car_key] int IDENTITY(1,1),
			[car_key] int not null,
			[insuree_key] int not null,
			[car_year_key] int not null,
			[car_make_key] varchar(50) not null,
			[car_model_key] varchar(50) not null,
		PRIMARY KEY NONCLUSTERED
		(
			[insuree_car_key] ASC
		) ON [PRIMARY],

		CONSTRAINT fk_carInsuree FOREIGN KEY (insuree_key) REFERENCES insuree_main(insuree_key),
		CONSTRAINT fk_carMake FOREIGN KEY (car_make_key) REFERENCES car_make(car_make_key),
		CONSTRAINT fk_carModel FOREIGN KEY (car_model_key) REFERENCES car_model(car_model_key),
		CONSTRAINT fk_carYear FOREIGN KEY (car_year_key) REFERENCES car_year(car_year_key)
	)

		CREATE UNIQUE NONCLUSTERED INDEX natKey_insureeCar ON insuree_car (
			[insuree_key]
		)
END

GO
IF OBJECT_ID('dbo.insuree_quote') is null
BEGIN
	-- associated quote
	CREATE TABLE insuree_quote (
			[quote_key] int IDENTITY(1,1),
			[insuree_key] int not null,
			[coverage_type] varchar(12) not null,
			[curr_quote] varchar(10) null,
			[prev_quote] varchar(10) null,
		PRIMARY KEY NONCLUSTERED
		(
			[quote_key] ASC
		) ON [PRIMARY],

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
			[hist_key] int IDENTITY(1,1),
			[insuree_key] int not null,
			[dui] varchar(5) null,
			[tickets] varchar(1) null,
		PRIMARY KEY NONCLUSTERED
		(
			[hist_key] ASC
		) ON [PRIMARY],

		CONSTRAINT fk_insureeHist FOREIGN KEY (insuree_key) REFERENCES insuree_main(insuree_key)
	)

		CREATE UNIQUE NONCLUSTERED INDEX natKey_insureeHist ON insuree_hist (
			[insuree_key]
		)
END

GO

-- dropdown tables for car information
IF OBJECT_ID('dbo.car_make') is null
BEGIN
	-- car make(s)
	CREATE TABLE car_make (
			[car_make_key] int IDENTITY(1,1),
			-- CD REMOVED [car_model_key] int not null,
			[car_make] varchar(20) not null,
		PRIMARY KEY NONCLUSTERED
		(
			[car_make_key] ASC
		) ON [PRIMARY],
	)
END

GO

IF OBJECT_ID('dbo.car_model') is null
BEGIN
	-- car models(s)
	CREATE TABLE car_model (
			[car_model_key] int IDENTITY(1,1),
			[car_make_key] int not null,
			[car_model] varchar(25) not null,
		PRIMARY KEY NONCLUSTERED
		(
			[car_model_key] ASC
		) ON [PRIMARY],

		CONSTRAINT fk_carModel FOREIGN KEY (car_make_key) REFERENCES car_make(car_make_key)
	)
END

GO

IF OBJECT_ID('dbo.car_year') is null
BEGIN
	-- car year(s)
	CREATE TABLE car_year (
			[car_year_key] int IDENTITY(1,1),
			[car_year] int not null,
		PRIMARY KEY NONCLUSTERED
		(
			[car_year_key] ASC
		) ON [PRIMARY],
	)
END

GO