SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    VIEW
[qpi].[perf_counters]
AS
SELECT * FROM qpi.fn_perf_counters(NULL);
GO
