CREATE TABLE [dbo].[sqlwatch_meta_server]
(
[physical_name] [nvarchar] (128) COLLATE Latin1_General_CI_AS NULL,
[servername] [varchar] (32) COLLATE Latin1_General_CI_AS NOT NULL,
[service_name] [nvarchar] (128) COLLATE Latin1_General_CI_AS NULL,
[local_net_address] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[local_tcp_port] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
[utc_offset_minutes] [int] NOT NULL,
[sql_version] [nvarchar] (2048) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO
