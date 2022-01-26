SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE  
FUNCTION [qpi].[cmp_query_plans] (@plan_id1 int, @plan_id2 int)
returns table
return (
	select a.[key], a.value value1, b.value value2
	from
	(select [key], value
	from openjson(
	(select *
		from sys.query_store_plan
		where plan_id = @plan_id1
		for json path, without_array_wrapper)
	)) as a ([key], value)
	join
	(select [key], value
	from openjson(
	(select *
		from sys.query_store_plan
		where plan_id = @plan_id2
		for json path, without_array_wrapper)
	)) as b ([key], value)
	on a.[key] = b.[key]
	where a.value <> b.value
);
GO
