SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE  
VIEW [qpi].[db_forced_queries]
AS
	SELECT name = CONCAT('FPQ-', query_id), query_id, text = text COLLATE Latin1_General_100_CI_AS, forced_plan_id = plan_id, hints = null from qpi.db_query_plans where is_forced_plan = 1
	UNION ALL
	SELECT name, q.query_id, text = query_text COLLATE Latin1_General_100_CI_AS, forced_plan_id = null, hints
		FROM sys.plan_guides pg
			LEFT JOIN qpi.db_queries q
			ON q.text COLLATE Latin1_General_100_CI_AS
			= pg.query_text COLLATE Latin1_General_100_CI_AS
		WHERE is_disabled = 0
GO
