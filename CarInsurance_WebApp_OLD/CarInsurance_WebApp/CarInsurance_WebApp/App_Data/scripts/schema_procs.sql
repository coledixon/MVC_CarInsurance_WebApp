/* SCHEMA FOR C# MVC WEB APPLICATION */
/* Copyright 2018 || Cole Dixon || All rights reserved */

USE [db_insurance]
GO

IF OBJECT_ID('dbo.spGetInsureeKey') is not null DROP PROC [dbo].[spGetInsureeKey] 
GO

	CREATE PROC spGetInsureeKey
	@insuree_key int OUTPUT
	AS
	DECLARE @retval int, @errmess varchar(250)

	SELECT @insuree_key = COALESCE(MAX(insuree_key),1)
		FROM insuree_main

		IF (COALESCE(@insuree_key,0) > 0)
		BEGIN
			SELECT @retval = 1
			GOTO SPEND
		END
		ELSE BEGIN
			SELECT @retval = -1, @errmess = 'error retreiving insuree_key in spGetInsureeKey'
			GOTO ERROR
		END

	SPEND:
		SELECT 'SUCCESS', @retval 'retval'
		RETURN

	ERROR:
		SELECT 'FAIL', @retval 'retval', @errmess 'errmess' 
		RETURN

GO
