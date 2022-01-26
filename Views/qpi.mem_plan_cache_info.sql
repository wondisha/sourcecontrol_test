SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO


CREATE    VIEW [qpi].[mem_plan_cache_info]
AS
SELECT  cached_object = objtype,
        memory_gb = SUM(size_in_bytes /1024 /1024 /1024),
		plan_count = COUNT_BIG(*),
		used_plans = SUM(usecounts),
		[references] = SUM(refcounts)
    FROM sys.dm_exec_cached_plans
    GROUP BY objtype
GO
