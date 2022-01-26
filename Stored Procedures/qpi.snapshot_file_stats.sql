SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE  
PROCEDURE [qpi].[snapshot_file_stats] @title nvarchar(200) = NULL, @db_name sysname = null, @file_name sysname = null
AS BEGIN
MERGE qpi.io_virtual_file_stats_snapshot AS Target
USING (
	SELECT db_name = DB_NAME(vfs.database_id),vfs.database_id,
		file_name = [mf].[name],size_gb = 8. * mf.size /1024/ 1024,[vfs].[file_id],
		[io_stall_read_ms],[io_stall_write_ms],[io_stall_queued_read_ms],[io_stall_queued_write_ms],[io_stall],
		[num_of_bytes_read], [num_of_bytes_written],
		[num_of_reads], [num_of_writes]
	FROM sys.dm_io_virtual_file_stats (db_id(@db_name),NULL) AS [vfs]



	JOIN sys.master_files AS [mf] ON

		[vfs].[database_id] = [mf].[database_id] AND [vfs].[file_id] = [mf].[file_id]
		AND (@file_name IS NULL OR [mf].[name] = @file_name)
	) AS Source
ON (Target.file_id = Source.file_id AND Target.database_id = Source.database_id)
WHEN MATCHED THEN
UPDATE SET
	Target.[size_gb] = Source.[size_gb], -- Target.[io_stall_read_ms],
	Target.[io_stall_read_ms] = Source.[io_stall_read_ms], -- Target.[io_stall_read_ms],
	Target.[io_stall_write_ms] = Source.[io_stall_write_ms], -- Target.[io_stall_write_ms],
	Target.[io_stall_queued_read_ms] = Source.[io_stall_queued_read_ms], -- Target.[io_stall_read_ms],
	Target.[io_stall_queued_write_ms] = Source.[io_stall_queued_write_ms], -- Target.[io_stall_write_ms],
	Target.[io_stall] = Source.[io_stall] ,-- Target.[io_stall],
	Target.[num_of_bytes_read] = Source.[num_of_bytes_read] ,-- Target.[num_of_bytes_read],
	Target.[num_of_bytes_written] = Source.[num_of_bytes_written] ,-- Target.[num_of_bytes_written],
	Target.[num_of_reads] = Source.[num_of_reads] ,-- Target.[num_of_reads],
	Target.[num_of_writes] = Source.[num_of_writes] ,-- Target.[num_of_writes],
	Target.title = ISNULL(@title, CONVERT(VARCHAR(30), GETDATE(), 20)) ,
	Target.interval_mi = DATEDIFF_BIG(mi, Target.start_time, GETUTCDATE())
WHEN NOT MATCHED BY TARGET THEN
INSERT (db_name,database_id,file_name,size_gb,[file_id],
    [io_stall_read_ms],[io_stall_write_ms],[io_stall_queued_read_ms],[io_stall_queued_write_ms],[io_stall],
    [num_of_bytes_read], [num_of_bytes_written],
    [num_of_reads], [num_of_writes], title)
VALUES (Source.db_name,Source.database_id,Source.file_name,Source.size_gb,Source.[file_id],Source.[io_stall_read_ms],Source.[io_stall_write_ms],Source.[io_stall_queued_read_ms],Source.[io_stall_queued_write_ms],Source.[io_stall],Source.[num_of_bytes_read],Source.[num_of_bytes_written],Source.[num_of_reads],Source.[num_of_writes], ISNULL(@title, CONVERT(VARCHAR(30), GETDATE(), 20)) );
END
GO
