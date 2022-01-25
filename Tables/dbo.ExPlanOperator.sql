CREATE TABLE [dbo].[ExPlanOperator]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[First_Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Last_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Address] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
CREATE CLUSTERED INDEX [IX_ExPlanOperator_ID] ON [dbo].[ExPlanOperator] ([ID]) WITH (FILLFACTOR=70) ON [PRIMARY]
GO
