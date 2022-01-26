SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
--------------------------------------------------------------------------------
-- the most important view: query statistics:
--------------------------------------------------------------------------------
-- Returns statistics about all queries as of specified time.
CREATE    FUNCTION [qpi].[db_query_exec_stats_as_of](@date datetime2)
returns table
return (

WITH query_stats as (
SELECT	qps.query_id, execution_type_desc,
		duration_s = AVG(duration_s),
		count_executions = SUM(count_executions),
		cpu_time_ms = AVG(cpu_time_ms),
		logical_io_reads_kb = AVG(logical_io_reads_kb),
		logical_io_writes_kb = AVG(logical_io_writes_kb),
		physical_io_reads_kb = AVG(physical_io_reads_kb),
		clr_time_ms = AVG(clr_time_ms),

		num_physical_io_reads = AVG(num_physical_io_reads),
		log_bytes_used_kb = AVG(log_bytes_used_kb),
		tempdb_used_mb = AVG(tempdb_used_mb),

		start_time = MIN(start_time),
		interval_mi = MIN(interval_mi)
FROM qpi.db_query_plan_exec_stats_as_of(@date) qps
GROUP BY query_id, execution_type_desc
)
SELECT  text =   IIF(LEFT(t.query_sql_text,1) = '(', TRIM(')' FROM SUBSTRING( t.query_sql_text, (PATINDEX( '%)[^),]%', t.query_sql_text))+1, LEN(t.query_sql_text))), t.query_sql_text) ,
		params =  IIF(LEFT(t.query_sql_text,1) = '(', SUBSTRING( t.query_sql_text, 2, (PATINDEX( '%)[^),]%', t.query_sql_text+')'))-2), "") ,
		qs.*,
		t.query_text_id,
		q.query_hash
FROM query_stats qs
	join sys.query_store_query q
	on q.query_id = qs.query_id
	join sys.query_store_query_text t
	on q.query_text_id = t.query_text_id

)
GO
