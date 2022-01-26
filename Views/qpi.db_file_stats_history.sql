SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    VIEW [qpi].[db_file_stats_history]
AS
select s.snapshot_name, s.start_time, fs.*
from qpi.file_stats_snapshots s
cross apply qpi.db_file_stats_at(s.snapshot_name) fs;
GO
