SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

------------------------------------------------------------------------------------
--	Query performance statistics.
------------------------------------------------------------------------------------

CREATE    VIEW [qpi].[blocked_queries]
AS
SELECT
	text = blocked.text,
	session_id = blocked.session_id,
	blocked_by_session_id = conn.session_id,
	blocked_by_query = last_query.text,
	wait_time_s = w.wait_duration_ms /1000,
	w.wait_type,
	locked_object_id = obj.object_id,
	locked_object_schema = SCHEMA_NAME(obj.schema_id),
	locked_object_name = obj.name,
	locked_object_type = obj.type_desc,
	locked_resource_type = tl.resource_type,
	locked_resource_db = DB_NAME(tl.resource_database_id),
	tl.request_mode,
	tl.request_type,
	tl.request_status,
	tl.request_owner_type,
	w.resource_description
FROM qpi.queries blocked with(nolock)
	INNER JOIN sys.dm_os_waiting_tasks w with(nolock)
	ON blocked.session_id = w.session_id
		INNER JOIN sys.dm_exec_connections conn with(nolock)
		ON conn.session_id =  w.blocking_session_id
			CROSS APPLY sys.dm_exec_sql_text(conn.most_recent_sql_handle) AS last_query
	LEFT JOIN sys.dm_tran_locks as tl with(nolock)
	 ON tl.lock_owner_address = w.resource_address
	 LEFT JOIN
	 	(SELECT p.object_id, p.hobt_id, au.allocation_unit_id
		 FROM sys.partitions p with(nolock)
		 LEFT JOIN sys.allocation_units AS au with(nolock)
		 ON (au.type IN (1,3) AND au.container_id = p.hobt_id)
            	OR
            (au.type = 2 AND au.container_id = p.partition_id)
		)
		AS p ON
			tl.resource_type IN ('PAGE','KEY','RID','HOBT') AND p.hobt_id = tl.resource_associated_entity_id
			OR
			tl.resource_type = 'ALLOCATION_UNIT' AND p.allocation_unit_id = tl.resource_associated_entity_id
		LEFT JOIN sys.objects obj with(nolock) ON p.object_id = obj.object_id
WHERE w.session_id <> w.blocking_session_id
GO
