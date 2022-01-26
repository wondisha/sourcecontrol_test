SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    VIEW [qpi].[query_locks]
AS
SELECT
	text = q.text,
	session_id = q.session_id,
	tl.request_owner_type,
	tl.request_status,
	tl.request_mode,
	tl.request_type,
	locked_object_id = obj.object_id,
	locked_object_schema = SCHEMA_NAME(obj.schema_id),
	locked_object_name = obj.name,
	locked_object_type = obj.type_desc,
	locked_resource_type = tl.resource_type,
	locked_resource_db = DB_NAME(tl.resource_database_id),
	q.request_id,
	tl.resource_associated_entity_id
FROM qpi.queries q with(nolock)
	JOIN sys.dm_tran_locks as tl with(nolock)
		ON q.session_id = tl.request_session_id and q.request_id = tl.request_request_id
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
GO
