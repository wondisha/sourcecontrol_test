SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE  
VIEW [qpi].[db_query_plan_exec_stats_ex]
AS SELECT * FROM qpi.db_query_plan_exec_stats_ex_as_of(GETUTCDATE());
GO
