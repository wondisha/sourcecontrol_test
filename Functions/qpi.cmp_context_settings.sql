SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    FUNCTION [qpi].[cmp_context_settings] (@ctx_id1 int, @ctx_id2 int)
returns table
return (
	select a.[key], a.value value1, b.value value2
	from
	(select [key], value
	from openjson(
	(select *
		from sys.query_context_settings
			cross apply qpi.decode_options(set_options)
		where context_settings_id = @ctx_id1
		for json path, without_array_wrapper)
	)) as a ([key], value)
	join
	(select [key], value
	from openjson(
	(select *
		from sys.query_context_settings
			cross apply qpi.decode_options(set_options)
		where context_settings_id = @ctx_id2
		for json path, without_array_wrapper)
	)) as b ([key], value)
	on a.[key] = b.[key]
	where a.value <> b.value
);


GO
