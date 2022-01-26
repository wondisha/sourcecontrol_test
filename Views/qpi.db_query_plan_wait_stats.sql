SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE  
VIEW [qpi].[db_query_plan_wait_stats]
AS SELECT * FROM  qpi.db_query_plan_wait_stats_as_of(GETUTCDATE());
GO
