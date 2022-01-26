SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    FUNCTION [qpi].[db_file_stats_as_of](@when datetime2(0))
RETURNS TABLE
AS RETURN (SELECT fs.* FROM qpi.fn_file_stats(DB_ID(), @when, null) fs
);
GO
