SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


-----------------------------------------------------------------------------
-- Core Database Query Store wait stat functionalities
-----------------------------------------------------------------------------
CREATE  
function [qpi].[db_query_plan_wait_stats_as_of](@date datetime2)
	returns table
as return (
select
		text =   IIF(LEFT(t.query_sql_text,1) = '(', TRIM(')' FROM SUBSTRING( t.query_sql_text, (PATINDEX( '%)[^),]%', t.query_sql_text))+1, LEN(t.query_sql_text))), t.query_sql_text) ,
		params =  IIF(LEFT(t.query_sql_text,1) = '(', SUBSTRING( t.query_sql_text, 2, (PATINDEX( '%)[^),]%', t.query_sql_text+')'))-2), "") ,
		category = ws.wait_category_desc,
		wait_time_ms = CAST(ROUND(ws.avg_query_wait_time_ms, 1) AS NUMERIC(12,1)),
		t.query_text_id, q.query_id, ws.plan_id, ws.execution_type_desc,
		rsi.start_time, rsi.end_time,
		interval_mi = datediff(mi, rsi.start_time, rsi.end_time),
		ws.runtime_stats_interval_id, ws.wait_stats_id, q.query_hash
from sys.query_store_query_text t
	join sys.query_store_query q on t.query_text_id = q.query_text_id
	join sys.query_store_plan p on p.query_id = q.query_id
	join sys.query_store_wait_stats ws on ws.plan_id = p.plan_id
	join sys.query_store_runtime_stats_interval rsi on ws.runtime_stats_interval_id = rsi.runtime_stats_interval_id
where @date is null or @date between rsi.start_time and rsi.end_time
);
GO
