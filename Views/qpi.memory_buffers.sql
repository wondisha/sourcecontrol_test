SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

-- www.mssqltips.com/sqlservertip/2393/determine-sql-server-memory-use-by-database-and-object/
CREATE    VIEW [qpi].[memory_buffers]
AS
WITH src AS
(
SELECT
database_id, db_buffer_pages = COUNT_BIG(*),
			read_time_ms = AVG(read_microsec)/1000.,
			modified_perc = (100*SUM(CASE WHEN is_modified = 1 THEN 1 ELSE 0 END))/COUNT_BIG(*)
FROM sys.dm_os_buffer_descriptors
--WHERE database_id BETWEEN 5 AND 32766 --> to exclude system databases
GROUP BY database_id WITH ROLLUP
)
SELECT
[db_name] = CASE WHEN [database_id] = 32767 THEN 'Resource DB'
WHEN [database_id] IS NULL THEN '--> TOTAL:'
ELSE DB_NAME([database_id]) END,
buffer_gb = db_buffer_pages / 128 /1024,
buffer_percent = CONVERT(DECIMAL(6,3),
db_buffer_pages * 100.0 / (SELECT top 1 cntr_value
							FROM sys.dm_os_performance_counters
							WHERE RTRIM([object_name]) LIKE '%Buffer Manager'
							AND counter_name = 'Database Pages')
),
read_time_ms,
modified_perc
FROM src
GO
