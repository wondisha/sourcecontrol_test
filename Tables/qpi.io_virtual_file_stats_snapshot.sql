CREATE TABLE [qpi].[io_virtual_file_stats_snapshot_history]
(
[db_name] [sys].[sysname] NULL,
[database_id] [smallint] NOT NULL,
[file_name] [sys].[sysname] NOT NULL,
[size_gb] [int] NOT NULL,
[file_id] [smallint] NOT NULL,
[io_stall_read_ms] [bigint] NOT NULL,
[io_stall_write_ms] [bigint] NOT NULL,
[io_stall_queued_read_ms] [bigint] NOT NULL,
[io_stall_queued_write_ms] [bigint] NOT NULL,
[io_stall] [bigint] NOT NULL,
[num_of_bytes_read] [bigint] NOT NULL,
[num_of_bytes_written] [bigint] NOT NULL,
[num_of_reads] [bigint] NOT NULL,
[num_of_writes] [bigint] NOT NULL,
[title] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[interval_mi] [bigint] NULL,
[start_time] [datetime2] NOT NULL,
[end_time] [datetime2] NOT NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE NONCLUSTERED INDEX [ix_file_snapshot_interval_history] ON [qpi].[io_virtual_file_stats_snapshot_history] ([end_time]) WITH (FILLFACTOR=70) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [ix_io_virtual_file_stats_snapshot_history] ON [qpi].[io_virtual_file_stats_snapshot_history] ([end_time], [start_time]) WITH (DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
CREATE TABLE [qpi].[io_virtual_file_stats_snapshot]
(
[db_name] [sys].[sysname] NULL,
[database_id] [smallint] NOT NULL,
[file_name] [sys].[sysname] NOT NULL,
[size_gb] [int] NOT NULL,
[file_id] [smallint] NOT NULL,
[io_stall_read_ms] [bigint] NOT NULL,
[io_stall_write_ms] [bigint] NOT NULL,
[io_stall_queued_read_ms] [bigint] NOT NULL,
[io_stall_queued_write_ms] [bigint] NOT NULL,
[io_stall] [bigint] NOT NULL,
[num_of_bytes_read] [bigint] NOT NULL,
[num_of_bytes_written] [bigint] NOT NULL,
[num_of_reads] [bigint] NOT NULL,
[num_of_writes] [bigint] NOT NULL,
[title] [nvarchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[interval_mi] [bigint] NULL,
[start_time] [datetime2] GENERATED ALWAYS AS ROW START NOT NULL,
[end_time] [datetime2] GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (start_time, end_time),
CONSTRAINT [PK__io_virtu__D5BA53FA2E378CD5] PRIMARY KEY CLUSTERED ([database_id], [file_id]) WITH (FILLFACTOR=70) ON [PRIMARY]
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [qpi].[io_virtual_file_stats_snapshot_history])
)
GO
ALTER TABLE [qpi].[io_virtual_file_stats_snapshot] ADD CONSTRAINT [CK__io_virtua__num_o__3BCADD1B] CHECK (([num_of_reads]>=(0)))
GO
ALTER TABLE [qpi].[io_virtual_file_stats_snapshot] ADD CONSTRAINT [CK__io_virtua__num_o__3CBF0154] CHECK (([num_of_writes]>=(0)))
GO
CREATE UNIQUE NONCLUSTERED INDEX [UQ_snapshot_title] ON [qpi].[io_virtual_file_stats_snapshot] ([title], [database_id], [file_id]) WITH (FILLFACTOR=70) ON [PRIMARY]
GO
