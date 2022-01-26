SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE    VIEW [qpi].[db_queries]
as
select	text =  IIF(LEFT(query_sql_text,1) = '(', TRIM(')' FROM SUBSTRING( query_sql_text, (PATINDEX( '%)[^),]%', query_sql_text))+1, LEN(query_sql_text))), query_sql_text) ,
		params =  IIF(LEFT(query_sql_text,1) = '(', SUBSTRING( query_sql_text, 2, (PATINDEX( '%)[^),]%', query_sql_text+')'))-2), "") ,
		q.query_text_id, query_id, context_settings_id, q.query_hash
from sys.query_store_query_text t
	join sys.query_store_query q on t.query_text_id = q.query_text_id
GO
