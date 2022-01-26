SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


-----------------------------------------------------------------------------
-- Core Server-level functionalities
-----------------------------------------------------------------------------
-- The list of currently executing queries that are probably not in Query Store.
CREATE    VIEW [qpi].[queries]
AS
SELECT
		text =   IIF(LEFT(text,1) = '(', TRIM(')' FROM SUBSTRING( text, (PATINDEX( '%)[^),]%', text))+1, LEN(text))), text) ,
		params =  IIF(LEFT(text,1) = '(', SUBSTRING( text, 2, (PATINDEX( '%)[^),]%', text+')'))-2), "") ,
		execution_type_desc = status COLLATE Latin1_General_CS_AS,
		first_execution_time = start_time, last_execution_time = NULL, count_executions = NULL,
		elapsed_time_s = total_elapsed_time /1000.0,
		cpu_time_s = cpu_time /1000.0,
		logical_io_reads = logical_reads,
		logical_io_writes = writes,
		physical_io_reads = reads,
		num_physical_io_reads = NULL,
		clr_time = NULL,
		dop,
		row_count,
		memory_mb = granted_query_memory *8 /1000,
		log_bytes = NULL,
		tempdb_space = NULL,
		query_text_id = NULL, query_id = NULL, plan_id = NULL,
		database_id, connection_id, session_id, request_id, command,
		interval_mi = null,
		start_time,
		end_time = null,
		sql_handle
FROM    sys.dm_exec_requests
		CROSS APPLY sys.dm_exec_sql_text(sql_handle)
WHERE text NOT LIKE '%qpi.queries%'
GO
