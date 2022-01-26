SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

--- Query comparison
CREATE      function [qpi].[cmp_query_exec_stats] (@query_id int, @date1 datetime2, @date2 datetime2)
returns table
return (
	select a.[key], a.value value1, b.value value2
	from
	(select [key], value
	from openjson(
	(select *
		from qpi.db_query_exec_stats_as_of(@date1)
		where query_id = @query_id
		for json path, without_array_wrapper)
	)) as a ([key], value)
	join
	(select [key], value
	from openjson(
	(select *
		from qpi.db_query_exec_stats_as_of(@date2)
		where query_id = @query_id
		for json path, without_array_wrapper)
	)) as b ([key], value)
	on a.[key] = b.[key]
	where a.value <> b.value
);
GO
