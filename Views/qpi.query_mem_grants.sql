SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    VIEW [qpi].[query_mem_grants]
AS
select q.text, q.params, q.query_id, q.session_id, q.request_id, q.memory_mb, q.start_time,
		required_mb = mg.required_memory_kb /1024,
		requested_mb = mg.requested_memory_kb /1024,
		granted_mb = mg.granted_memory_kb /1024,
		used_mb = mg.used_memory_kb /1024,
		max_used_mb = mg.max_used_memory_kb /1024,
		ideal_mb = mg.ideal_memory_kb /1024,
		timeout_s = mg.timeout_sec,
		mg.wait_time_ms,
		mg.is_next_candidate
from qpi.queries q
left join sys.dm_exec_query_memory_grants mg
on q.session_id = mg.session_id
and q.request_id = mg.request_id
GO
