SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


-----------------------------------------------------------------------------
-- Core Plan forcing functionalities
-----------------------------------------------------------------------------
CREATE  
PROCEDURE [qpi].[force] @query_id int, @plan_id int = null, @hints nvarchar(4000) = null
AS BEGIN
	declare @guide sysname = CONCAT('QPI-PG-', @query_id),
			@sql nvarchar(max),
			@param nvarchar(max),
			@exists bit = 0;
	select @sql = text, @param =  IIF(LEFT(params,1) = '(', SUBSTRING( params, 2, (PATINDEX( '%)[^),]%', params+')'))-2), "")
	from qpi.db_queries
	where query_id = @query_id;
	select @guide = name, @exists = 1 from sys.plan_guides where query_text = @sql or name = @guide;
	if (@exists = 1) begin
		PRINT 'Removing existing plan guide ' + @guide;
		EXEC sp_control_plan_guide N'DROP', @guide;
	end;

	if(@plan_id is not null)
		EXEC sp_query_store_force_plan @query_id, @plan_id;
	else if (@hints is not null)
	begin
		SET @param = IIF(@param = "", null, @param);
		IF substring(@hints, 1,7) <> 'OPTION'
			SET @hints = 'OPTION(' + @hints + ')';
		PRINT 'Forcing hint ' + @hints + ' on query ' + @sql;
		EXEC sp_create_plan_guide @name = @guide,
			@stmt = @sql,
			@type = N'SQL',
			@module_or_batch = NULL,
			@params = @param,
			@hints = @hints;
	end
END
GO
