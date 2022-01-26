SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    VIEW [qpi].[db_query_plans_ex]
as
select	q.text, q.params, q.query_text_id, p.*, q.query_hash
from sys.query_store_plan p
	join qpi.db_queries q
		on p.query_id = q.query_id;
GO
