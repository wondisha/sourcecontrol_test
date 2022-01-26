SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    VIEW [qpi].[db_queries_ex]
as
select	q.text, q.params, q.query_text_id, query_id, q.context_settings_id, q.query_hash,
		o.*
FROM qpi.db_queries q
		JOIN sys.query_context_settings ctx
			ON q.context_settings_id = ctx.context_settings_id
			CROSS APPLY qpi.decode_options(ctx.set_options) o
GO
