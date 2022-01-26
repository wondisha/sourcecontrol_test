SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    VIEW [qpi].[file_stats_snapshots]
AS
SELECT DISTINCT snapshot_name = title, start_time, end_time
FROM qpi.io_virtual_file_stats_snapshot FOR SYSTEM_TIME ALL
GO
