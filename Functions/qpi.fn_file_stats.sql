SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    FUNCTION [qpi].[fn_file_stats](@database_id int, @end_date datetime2 = null, @milestone nvarchar(100) = null)
RETURNS TABLE
AS RETURN (
	-- for testing: DECLARE @database_id int = DB_ID(), @end_date datetime2 = null, @milestone nvarchar(100) = null;
with cur (	[database_id],[file_id],[size_gb],[io_stall_read_ms],[io_stall_write_ms],[io_stall_queued_read_ms],[io_stall_queued_write_ms],[io_stall],
				[num_of_bytes_read], [num_of_bytes_written], [num_of_reads], [num_of_writes], title, start_time, end_time)
	as (
			SELECT	s.database_id, [file_id],[size_gb],[io_stall_read_ms],[io_stall_write_ms],[io_stall_queued_read_ms],[io_stall_queued_write_ms],[io_stall],
					[num_of_bytes_read], [num_of_bytes_written], [num_of_reads], [num_of_writes],
					title, start_time, end_time
			FROM qpi.io_virtual_file_stats_snapshot for system_time as of @end_date s
			WHERE @end_date is not null
			AND (@database_id is null or s.database_id = @database_id)
			UNION ALL
			SELECT	database_id,[file_id],[size_gb],[io_stall_read_ms],[io_stall_write_ms],[io_stall_queued_read_ms],[io_stall_queued_write_ms],[io_stall],
					[num_of_bytes_read], [num_of_bytes_written], [num_of_reads], [num_of_writes],
					title, start_time, end_time
			FROM qpi.io_virtual_file_stats_snapshot for system_time all as s
			WHERE @milestone is not null
			AND title = @milestone
			AND (@database_id is null or s.database_id = @database_id)
			UNION ALL
			SELECT	s.database_id,s.[file_id],[size_gb]=8.*mf.size/1024/1024,[io_stall_read_ms],[io_stall_write_ms],[io_stall_queued_read_ms],[io_stall_queued_write_ms],[io_stall],
						[num_of_bytes_read], [num_of_bytes_written], [num_of_reads], [num_of_writes],
						title = 'Latest', start_time = GETUTCDATE(), end_time = CAST('9999-12-31T00:00:00.0000' AS DATETIME2)

				FROM sys.dm_io_virtual_file_stats (@database_id, null) s
					JOIN sys.master_files mf ON mf.database_id = s.database_id AND mf.file_id = s.file_id
			WHERE @milestone is null AND @end_date is null
		)
		SELECT
		db_name = prev.db_name,
		file_name = prev.file_name,
		cur.size_gb,
		throughput_mbps
			= CAST((cur.num_of_bytes_read - prev.num_of_bytes_read)/1024.0/1024.0 / (DATEDIFF(millisecond, prev.start_time, cur.start_time) / 1000.) AS numeric(10,2))
			+ CAST((cur.num_of_bytes_written - prev.num_of_bytes_written)/1024.0/1024.0 / (DATEDIFF(millisecond, prev.start_time, cur.start_time) / 1000.) AS numeric(10,2)),
		read_mbps
			= CAST((cur.num_of_bytes_read - prev.num_of_bytes_read)/1024.0/1024.0 / (DATEDIFF(millisecond, prev.start_time, cur.start_time) / 1000.) AS numeric(10,2)),
		write_mbps
			= CAST((cur.num_of_bytes_written - prev.num_of_bytes_written)/1024.0/1024.0 / (DATEDIFF(millisecond, prev.start_time, cur.start_time) / 1000.) AS numeric(10,2)),
		iops
			= CAST((cur.num_of_reads - prev.num_of_reads + cur.num_of_writes - prev.num_of_writes)/ (DATEDIFF(millisecond, prev.start_time, cur.start_time) / 1000.) AS numeric(10,0)),
		read_iops
			= CAST((cur.num_of_reads - prev.num_of_reads)/ (DATEDIFF(millisecond, prev.start_time, cur.start_time) / 1000.) AS numeric(10,0)),
		write_iops
			= CAST((cur.num_of_writes - prev.num_of_writes)/ (DATEDIFF(millisecond, prev.start_time, cur.start_time) / 1000.) AS numeric(10,0)),
		latency_ms
			= CASE WHEN ( (cur.num_of_reads - prev.num_of_reads) = 0 AND (cur.num_of_writes - prev.num_of_writes) = 0)
				THEN NULL ELSE (CAST(ROUND(1.0 * (cur.io_stall - prev.io_stall) / ((cur.num_of_reads - prev.num_of_reads) + (cur.num_of_writes - prev.num_of_writes)), 1) AS numeric(10,1))) END,
		read_latency_ms
			= CASE WHEN (cur.num_of_reads - prev.num_of_reads) = 0
				THEN NULL ELSE (CAST(ROUND(1.0 * (cur.io_stall_read_ms - prev.io_stall_read_ms) / (cur.num_of_reads - prev.num_of_reads), 1) AS numeric(10,1))) END,
		write_latency_ms
			= CASE WHEN (cur.num_of_writes - prev.num_of_writes) = 0
				THEN NULL ELSE (CAST(ROUND(1.0 * (cur.io_stall_write_ms - prev.io_stall_write_ms) / (cur.num_of_writes - prev.num_of_writes), 1) AS numeric(10,1))) END,
		read_io_latency_ms =
			CASE WHEN (cur.num_of_reads - prev.num_of_reads) = 0
				THEN NULL ELSE
			CAST(ROUND(((cur.io_stall_read_ms-cur.io_stall_queued_read_ms) - (prev.io_stall_read_ms - prev.io_stall_queued_read_ms))/(cur.num_of_reads - prev.num_of_reads),2) AS NUMERIC(10,2))
			END,
		write_io_latency_ms =
		CASE WHEN (cur.num_of_writes - prev.num_of_writes) = 0
				THEN NULL
				ELSE CAST(ROUND(((cur.io_stall_write_ms-cur.io_stall_queued_write_ms) - (prev.io_stall_write_ms - prev.io_stall_queued_write_ms))/(cur.num_of_writes - prev.num_of_writes),2) AS NUMERIC(10,2))
			END,
		kb_per_read
			= CASE WHEN (cur.num_of_reads - prev.num_of_reads) = 0
				THEN NULL ELSE CAST(((cur.num_of_bytes_read - prev.num_of_bytes_read) / (cur.num_of_reads - prev.num_of_reads))/1024.0 AS numeric(10,1)) END,
		kb_per_write
			= CASE WHEN (cur.num_of_writes - prev.num_of_writes) = 0
				THEN NULL ELSE CAST(((cur.num_of_bytes_written - prev.num_of_bytes_written) / (cur.num_of_writes - prev.num_of_writes))/1024.0 AS numeric(10,1)) END,
		kb_per_io
			= CASE WHEN ((cur.num_of_reads - prev.num_of_reads) = 0 AND (cur.num_of_writes - prev.num_of_writes) = 0)
				THEN NULL ELSE CAST(
					(((cur.num_of_bytes_read - prev.num_of_bytes_read) + (cur.num_of_bytes_written - prev.num_of_bytes_written)) /
					((cur.num_of_reads - prev.num_of_reads) + (cur.num_of_writes - prev.num_of_writes)))/1024.0
					 AS numeric(10,1)) END,
		read_mb = CAST((cur.num_of_bytes_read - prev.num_of_bytes_read)/1024.0/1024 AS numeric(10,2)),
		write_mb = CAST((cur.num_of_bytes_written - prev.num_of_bytes_written)/1024.0/1024 AS numeric(10,2)),
		num_of_reads = cur.num_of_reads - prev.num_of_reads,
		num_of_writes = cur.num_of_writes - prev.num_of_writes,
		interval_mi = DATEDIFF(minute, prev.start_time, cur.start_time),
		[type] = mf.type_desc
	FROM cur
		JOIN qpi.io_virtual_file_stats_snapshot for system_time all as prev
			ON cur.file_id = prev.file_id
			AND cur.database_id = prev.database_id
			AND (
				((@end_date is not null or @milestone is not null) and cur.start_time = prev.end_time)	-- cur is snapshot history => get the previous snapshot history record
				OR
				((@end_date is null and @milestone is null) and prev.end_time > GETUTCDATE())				-- cur is dm_io_virtual_file_stats => get the latest snapshot history record
			)

		JOIN sys.master_files mf ON cur.database_id = mf.database_id AND cur.file_id = mf.file_id
	WHERE (@database_id is null or @database_id = prev.database_id)
)
GO
