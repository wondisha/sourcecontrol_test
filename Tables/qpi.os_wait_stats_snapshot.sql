CREATE TABLE [qpi].[os_wait_stats_snapshot_history]
(
[category_id] [tinyint] NULL,
[wait_type] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[waiting_tasks_count] [bigint] NOT NULL,
[wait_time_s] [bigint] NOT NULL,
[max_wait_time_ms] [bigint] NOT NULL,
[signal_wait_time_s] [bigint] NOT NULL,
[title] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[start_time] [datetime2] NOT NULL,
[end_time] [datetime2] NOT NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE NONCLUSTERED INDEX [ix_dm_os_wait_stats_snapshot] ON [qpi].[os_wait_stats_snapshot_history] ([end_time]) WITH (FILLFACTOR=70) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [ix_os_wait_stats_snapshot_history] ON [qpi].[os_wait_stats_snapshot_history] ([end_time], [start_time]) WITH (DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
CREATE TABLE [qpi].[os_wait_stats_snapshot]
(
[category_id] [tinyint] NULL,
[wait_type] [nvarchar] (60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[waiting_tasks_count] [bigint] NOT NULL,
[wait_time_s] [bigint] NOT NULL,
[max_wait_time_ms] [bigint] NOT NULL,
[signal_wait_time_s] [bigint] NOT NULL,
[title] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[start_time] [datetime2] GENERATED ALWAYS AS ROW START NOT NULL,
[end_time] [datetime2] GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (start_time, end_time),
CONSTRAINT [PK__os_wait___B5447284BE10A7A0] PRIMARY KEY CLUSTERED ([wait_type]) WITH (FILLFACTOR=70) ON [PRIMARY]
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [qpi].[os_wait_stats_snapshot_history])
)
GO
