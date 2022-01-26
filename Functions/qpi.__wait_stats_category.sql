SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    FUNCTION [qpi].[__wait_stats_category](@category_id tinyint)
RETURNS TABLE
AS RETURN ( SELECT
			CASE @category_id
				WHEN 0 THEN 'Unknown'
				WHEN 1 THEN 'CPU'
				WHEN 2 THEN 'Worker Thread'
				WHEN 3 THEN 'Lock'
				WHEN 4 THEN 'Latch'
				WHEN 5 THEN 'Buffer Latch'
				WHEN 6 THEN 'Buffer IO'
				WHEN 7 THEN 'Compilation'
				WHEN 8 THEN 'SQL CLR'
				WHEN 9 THEN 'Mirroring'
				WHEN 10 THEN 'Transaction'
				WHEN 11 THEN 'Idle'
				WHEN 12 THEN 'Preemptive'
				WHEN 13 THEN 'Service Broker'
				WHEN 14 THEN 'Tran Log IO'
				WHEN 15 THEN 'Network IO'
				WHEN 16 THEN 'Parallelism'
				WHEN 17 THEN 'Memory'
				WHEN 18 THEN 'User Wait'
				WHEN 19 THEN 'Tracing'
				WHEN 20 THEN 'Full Text Search'
				WHEN 21 THEN 'Other Disk IO'
				WHEN 22 THEN 'Replication'
				WHEN 23 THEN 'Log Rate Governor'
			END AS category
);
GO
