SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    VIEW [qpi].[db_query_plans]
as
select	q.text, q.params, q.query_text_id, p.plan_id, p.query_id,
		p.compatibility_level, p.query_plan_hash, p.count_compiles,
		p.is_parallel_plan, p.is_forced_plan, p.query_plan, q.query_hash
from sys.query_store_plan p
	join qpi.db_queries q
		on p.query_id = q.query_id;
GO
