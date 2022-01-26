SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    FUNCTION [qpi].[db_file_stats_at](@milestone nvarchar(100))
RETURNS TABLE
AS RETURN (
	SELECT * FROM qpi.fn_file_stats(DB_ID(), null, @milestone)
);
GO
