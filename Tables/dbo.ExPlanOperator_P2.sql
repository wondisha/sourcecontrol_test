CREATE TABLE [dbo].[ExPlanOperator_P2]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[EmpFirst_Name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmpLast_name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmpAddress] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EmpPhoneNum] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
