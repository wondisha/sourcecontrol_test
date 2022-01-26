SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE  
function [qpi].[db_query_wait_stats_as_of](@date datetime2)
	returns table
as return (
	select
		text = min(text),
		params = min(params),
		category, wait_time_ms = sum(wait_time_ms),
		query_text_id,
		query_id,
		execution_type_desc,
		start_time = min(start_time), end_time = min(end_time),
		interval_mi = min(interval_mi)
from qpi.db_query_plan_wait_stats_as_of(@date)
group by query_id, query_text_id, category, execution_type_desc
);
GO
