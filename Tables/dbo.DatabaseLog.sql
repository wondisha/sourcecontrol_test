CREATE TABLE [dbo].[DatabaseLog]
(
[DatabaseLogID] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[PostTime] [datetime] NOT NULL,
[DatabaseUser] [sys].[sysname] NOT NULL,
[Event] [sys].[sysname] NOT NULL,
[Schema] [sys].[sysname] NULL,
[Object] [sys].[sysname] NULL,
[TSQL] [nvarchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[XmlEvent] [xml] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DatabaseLog] ADD CONSTRAINT [PK_DatabaseLog_DatabaseLogID] PRIMARY KEY NONCLUSTERED ([DatabaseLogID]) ON [PRIMARY]
GO
