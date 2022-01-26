CREATE TABLE [qpi].[os_performance_counters_snapshot_history]
(
[name] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[value] [decimal] (18, 0) NOT NULL,
[object] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[instance_name] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[type] [int] NOT NULL,
[start_time] [datetime2] NOT NULL,
[end_time] [datetime2] NOT NULL
) ON [PRIMARY]
WITH
(
DATA_COMPRESSION = PAGE
)
GO
CREATE CLUSTERED INDEX [ix_os_performance_counters_snapshot_history] ON [qpi].[os_performance_counters_snapshot_history] ([end_time], [start_time]) WITH (DATA_COMPRESSION = PAGE) ON [PRIMARY]
GO
CREATE TABLE [qpi].[os_performance_counters_snapshot]
(
[name] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[value] [decimal] (18, 0) NOT NULL,
[object] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[instance_name] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[type] [int] NOT NULL,
[start_time] [datetime2] GENERATED ALWAYS AS ROW START NOT NULL,
[end_time] [datetime2] GENERATED ALWAYS AS ROW END NOT NULL,
PERIOD FOR SYSTEM_TIME (start_time, end_time),
CONSTRAINT [PK__os_perfo__DFE47B6F33BBC1BB] PRIMARY KEY CLUSTERED ([type], [name], [object], [instance_name]) WITH (FILLFACTOR=70) ON [PRIMARY]
) ON [PRIMARY]
WITH
(
SYSTEM_VERSIONING = ON (HISTORY_TABLE = [qpi].[os_performance_counters_snapshot_history])
)
GO
