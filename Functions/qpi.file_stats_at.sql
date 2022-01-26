SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    FUNCTION [qpi].[file_stats_at](@milestone nvarchar(100))
RETURNS TABLE
AS RETURN (
	SELECT * FROM qpi.fn_file_stats(null, null, @milestone)
);
GO
