SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE  
VIEW [qpi].[wait_stats_history]
AS SELECT * FROM  qpi.wait_stats_as_of(null);
GO
