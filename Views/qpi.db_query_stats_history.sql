SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    VIEW
[qpi].[db_query_stats_history]
AS

WITH ws AS(
	SELECT query_id, start_time, execution_type_desc,
			wait_time_ms = SUM(wait_time_ms)
	FROM qpi.db_query_wait_stats_history
	GROUP BY query_id, start_time, execution_type_desc
)

SELECT text, params, qes.execution_type_desc, qes.query_id, count_executions, duration_s, cpu_time_ms,

 wait_time_ms,
 log_bytes_used_kb,

 logical_io_reads_kb, logical_io_writes_kb, physical_io_reads_kb, clr_time_ms, qes.start_time, qes.query_hash
FROM qpi.db_query_exec_stats_history qes

	LEFT JOIN ws ON qes.query_id = ws.query_id
				AND qes.start_time = ws.start_time
				AND qes.execution_type_desc = ws.execution_type_desc

GO
