SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    VIEW
[qpi].[db_perf_counters]
AS
SELECT * FROM qpi.perf_counters
WHERE instance_name = db_name()
GO
