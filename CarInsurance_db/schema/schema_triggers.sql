/* SCHEMA FOR C# MVC WEB APPLICATION */
/* Copyright 2018 || Cole Dixon || All rights reserved */

USE [db_insurance]
GO


/* --- TRIGGERS --- */
-- drop and create in case of master schema changes

-----
--- INSERT/UPDATE TRIGGER on vinsuree_data_all
-----
IF OBJECT_ID('dbo.trINSUPD_vinsuree_data_all') is not null DROP TRIGGER [dbo].[trINSUPD_vinsuree_data_all] 
GO

	CREATE TRIGGER [dbo].[trINSUPD_vinsuree_data_all] ON [dbo].[vinsuree_data_all]
	INSTEAD OF INSERT, UPDATE
	AS
	BEGIN
		DECLARE @insuree_key int, @prevquote varchar(10), @retval int, @errmess varchar(MAX)

		-- create temp table
		SELECT inserted.* INTO #temp FROM inserted
			-- ALTER TABLE #temp ADD insuree_key int -- add key column for filtering
		
		-- validate if record already exists
		SELECT @insuree_key = exist.insuree_key
			FROM insuree_main exist 
			JOIN inserted i (NOLOCK) ON i.first_name = exist.first_name AND i.last_name = exist.last_name -- i.insuree_key = exist.insuree_key

		-- handle insert / update logic
		IF (COALESCE(@insuree_key,0) > 0)
		BEGIN

			UPDATE #temp SET insuree_key = @insuree_key -- set temp val

			-- update existing records
			UPDATE exist SET car_year = i.car_year, car_model = i.car_model, car_make = i.car_make
				FROM inserted i
				JOIN car_main exist (NOLOCK) ON exist.insuree_key = i.insuree_key

			UPDATE exist SET first_name = i.first_name, last_name = i.last_name, upd_date = GETDATE()
				FROM inserted i 
				JOIN insuree_main exist (NOLOCK) ON exist.insuree_key = i.insuree_key

			UPDATE exist SET email = i.email, dob = i.dob, state = i.state, zip = i.zip
				FROM inserted i
				JOIN insuree_info exist (NOLOCK) ON exist.insuree_key = i.insuree_key

			-- set previous quote for record
			SELECT @prevquote = curr.curr_quote 
				FROM insuree_quote curr
				JOIN inserted i (NOLOCK) ON i.insuree_key = curr.insuree_key 
			
			UPDATE	exist SET coverage_type = i.coverage_type, curr_quote = i.curr_quote, prev_quote = COALESCE(@prevquote,'0.00')
				FROM inserted i
				JOIN insuree_quote exist (NOLOCK) ON exist.insuree_key = i.insuree_key

			UPDATE exist SET tickets = i.tickets, dui = i.dui
				FROM inserted i
				JOIN insuree_hist exist (NOLOCK) ON exist.insuree_key = i.insuree_key
			
			IF @@ROWCOUNT = 0
			BEGIN
				SELECT @retval = -1, @errmess = 'NO RECORD(S) UPDATED IN trINSUPD_vinsuree_data_all'
				GOTO ERROR
			END
		END
		ELSE BEGIN

			-- create new records
			INSERT insuree_main (first_name, last_name, create_date)
			SELECT first_name, last_name, GETDATE() FROM inserted i

			IF @@ROWCOUNT > 1
			BEGIN
				-- get new insuree_key on create record
				SELECT @insuree_key = MAX(insuree_key) FROM insuree_main im

				IF (COALESCE(@insuree_key,0) = 0) 
					SET @insuree_key = 1 -- default to a value
			END

			INSERT car_main
			SELECT @insuree_key, car_year, car_make, car_model FROM inserted i 

			INSERT insuree_info
			SELECT @insuree_key, email, dob, state, zip FROM inserted i 

			INSERT insuree_hist
			SELECT @insuree_key, dui, tickets FROM inserted i 

			INSERT insuree_quote
			SELECT @insuree_key, coverage_type, curr_quote, null FROM inserted i 

				SELECT @retval = 1, @errmess = NULL -- assume success if reach this point
				GOTO SPEND
		END

		SPEND:
			SELECT 'SUCCESS'
			RETURN

		ERROR:
			SELECT 'FAIL', @retval retval, @errmess err
			RETURN
	END

GO

-----
--- DELETE TRIGGER on vinsuree_data_all
-----
IF OBJECT_ID('dbo.trDEL_vinsuree_data_all') is not null DROP TRIGGER [dbo].[trDEL_vinsuree_data_all] 
GO

	CREATE TRIGGER [dbo].[trDEL_vinsuree_data_all] ON [dbo].[vinsuree_data_all]
	INSTEAD OF DELETE
	AS
	BEGIN
		DECLARE @insuree_key int, @retval int, @errmess varchar(MAX)

		-- create temp table
		SELECT * INTO #temp FROM deleted

		-- begin cascading delete of record(s)
		SELECT @insuree_key = COALESCE(insuree_key,0) FROM #temp

			IF (COALESCE(@insuree_key,0) = 0)
			BEGIN
				SELECT @retval = -1, @errmess = 'ERROR RETRIEVING insuree_key FROM #temp IN trDEL_vinsuree_data_all'
				GOTO ERROR
			END

		BEGIN TRAN
			DELETE FROM insuree_hist WHERE insuree_key = @insuree_key

			DELETE FROM insuree_info WHERE insuree_key = @insuree_key

			DELETE FROM insuree_quote WHERE insuree_key = @insuree_key

			DELETE FROM car_main WHERE insuree_key = @insuree_key

			DELETE FROM insuree_main WHERE insuree_key = @insuree_key -- delete this record last due to FK constraints

			IF @@ROWCOUNT = 0
			BEGIN
				SELECT @retval = -1, @errmess = 'ERROR DELETING RECORD(S) IN trDEL_vinsuree_data_all'
				GOTO ERROR
			END
			ELSE BEGIN
				SELECT @retval = 1 -- assume success
				GOTO SPEND
			END

		SPEND:
			COMMIT TRAN -- finalize transaction
			SELECT 'SUCCESS', @retval retval
			RETURN

		ERROR:
			ROLLBACK TRAN -- undo transaction
			SELECT 'FAIL', @retval retval, @errmess err
			RETURN
	END

GO
