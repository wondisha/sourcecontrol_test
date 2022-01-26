SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE    VIEW [qpi].[query_stats]
AS
select q.text, q.params, q.query_id, q.session_id, q.request_id, q.memory_mb, q.start_time,
		duration_s = CAST(ROUND( rs.total_elapsed_time/execution_count /1000.0 /1000.0, 2) AS NUMERIC(12,2)),
        cpu_time_ms = CAST(ROUND(rs.total_worker_time/execution_count, 1) AS NUMERIC(12,1)),
        logical_io_reads_kb = CAST(ROUND(rs.total_logical_reads/execution_count * 8 /1000.0, 2) AS NUMERIC(12,2)),
        logical_io_writes_kb = CAST(ROUND(rs.total_logical_writes/execution_count * 8 /1000.0, 2) AS NUMERIC(12,2)),
        physical_io_reads_kb = CAST(ROUND(rs.total_physical_reads/execution_count * 8 /1000.0, 2) AS NUMERIC(12,2)),
        clr_time_ms = CAST(ROUND(rs.total_clr_time/execution_count /1000.0, 1) AS NUMERIC(12,1)),
		granted_mb = rs.total_grant_kb/execution_count /1024,
		used_mb = rs.total_used_grant_kb/execution_count /1024,
		ideal_mb = rs.total_ideal_grant_kb/execution_count /1024
from qpi.queries q
left join sys.dm_exec_query_stats rs
on q.sql_handle = rs.sql_handle
GO
