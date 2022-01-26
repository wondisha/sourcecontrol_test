SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE    VIEW [qpi].[db_query_exec_stats_history]
AS SELECT * FROM  qpi.db_query_exec_stats_as_of(NULL);
GO
