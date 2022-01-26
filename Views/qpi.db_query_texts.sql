SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    VIEW [qpi].[db_query_texts]
as
select	q.text, q.params, q.query_text_id, queries =  string_agg(concat(query_id,'(', context_settings_id,')'),',')
from qpi.db_queries q
group by q.text, q.params, q.query_text_id
GO
