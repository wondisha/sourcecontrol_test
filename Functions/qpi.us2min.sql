SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

-----------------------------------------------------------------------------
-- Generic utilities
-----------------------------------------------------------------------------
CREATE    FUNCTION [qpi].[us2min](@microseconds bigint)
RETURNS INT
AS BEGIN RETURN ( @microseconds /1000 /1000 /60 ) END;
GO
