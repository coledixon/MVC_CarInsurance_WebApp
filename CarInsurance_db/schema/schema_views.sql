/* SCHEMA FOR C# MVC WEB APPLICATION */
/* Copyright 2018 || Cole Dixon || All rights reserved */

USE [db_insurance]
GO


/* --- VIEWS --- */
-- drop and create in case of master schema changes

-----
--- VIEW for all related insuree data
-----
IF OBJECT_ID('dbo.vinsuree_data_all') is not null DROP VIEW [dbo].[vinsuree_data_all]
GO

	CREATE VIEW [dbo].[vinsuree_data_all]
	AS
	SELECT main.insuree_key, first_name, last_name, email, dob, state, zip,
		car_year, car_make, car_model, coverage_type, dui, tickets, curr_quote, prev_quote  
		FROM insuree_main main
			LEFT JOIN insuree_info info (NOLOCK) ON main.insuree_key = info.insuree_key
			LEFT JOIN car_main car (NOLOCK) ON info.insuree_key = car.insuree_key
			LEFT JOIN insuree_quote quote (NOLOCK) ON car.insuree_key = quote.insuree_key
			LEFT JOIN insuree_hist hist (NOLOCK) ON quote.insuree_key = hist.insuree_key

	GO

-----
--- VIEW for user login information
-----
IF OBJECT_ID('dbo.vlogin_user_all') is not null  DROP VIEW [dbo].[vlogin_user_all]
GO

	CREATE VIEW [dbo].[vlogin_user_all]
	AS
	SELECT insuree_key, lm.login_user_key, lm.username, lm.password, first_name, last_name
		FROM login_main lm
		LEFT JOIN insuree_main im (NOLOCK) ON lm.login_user_key = im.login_user_key

	GO