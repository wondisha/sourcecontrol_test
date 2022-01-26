SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE     function [qpi].[wait_stats_as_of](@date datetime2)
returns table
as return (
select
			category = c.category,
			wait_type,
			wait_time_s = wait_time_s,
			wait_per_task_ms = 100. * wait_time_s / case when waiting_tasks_count = 0 then null else waiting_tasks_count end,
			avg_wait_time = wait_time_s / DATEDIFF(s, start_time, GETUTCDATE()),
			signal_wait_time_s = signal_wait_time_s,
			avg_signal_wait_time = signal_wait_time_s / DATEDIFF(s, start_time, GETUTCDATE()),
			max_wait_time_s = CAST(ROUND(max_wait_time_ms /1000.,1) AS NUMERIC(12,1)),
			category_id,
			snapshot_time = start_time
from qpi.os_wait_stats_snapshot for system_time all rsi
	cross apply qpi.__wait_stats_category(category_id) as c
where @date is null or @date between rsi.start_time and rsi.end_time
);
GO
