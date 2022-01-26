SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO



CREATE    VIEW [qpi].[volumes]
AS
SELECT	volume_mount_point,
		used_gb = CAST(MIN(total_bytes / 1024. / 1024 / 1024) AS NUMERIC(10,1)),
		available_gb = CAST(MIN(available_bytes / 1024. / 1024 / 1024) AS NUMERIC(10,1)),
		total_gb = CAST(MIN((total_bytes+available_bytes) / 1024. / 1024 / 1024) AS NUMERIC(10,1))
FROM sys.master_files AS f
CROSS APPLY sys.dm_os_volume_stats(f.database_id, f.file_id)
GROUP BY volume_mount_point;
GO
