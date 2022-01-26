SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE  
VIEW [qpi].[db_query_wait_stats_history]
as select * from qpi.db_query_wait_stats_as_of(null)
GO
