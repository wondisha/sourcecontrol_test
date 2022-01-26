CREATE TABLE [dbo].[FactSalesQuota]
(
[SalesQuotaKey] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[EmployeeKey] [int] NOT NULL,
[DateKey] [int] NOT NULL,
[CalendarYear] [smallint] NOT NULL,
[CalendarQuarter] [tinyint] NOT NULL,
[SalesAmountQuota] [money] NOT NULL,
[Date] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactSalesQuota] ADD CONSTRAINT [PK_FactSalesQuota_SalesQuotaKey] PRIMARY KEY CLUSTERED ([SalesQuotaKey]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactSalesQuota] ADD CONSTRAINT [FK_FactSalesQuota_DimDate] FOREIGN KEY ([DateKey]) REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactSalesQuota] ADD CONSTRAINT [FK_FactSalesQuota_DimEmployee] FOREIGN KEY ([EmployeeKey]) REFERENCES [dbo].[DimEmployee] ([EmployeeKey])
GO
