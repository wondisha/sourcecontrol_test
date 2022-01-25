CREATE TABLE [dbo].[EMP_Salaries]
(
[EMP_ID] [int] NOT NULL IDENTITY(1, 1),
[EMP_HireDate] [datetime] NULL,
[EMP_Salary] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[EMP_Salaries] ADD CONSTRAINT [FK_EMP_Salaries_Employee_Main] FOREIGN KEY ([EMP_ID]) REFERENCES [dbo].[Employee_Main] ([Emp_ID])
GO
