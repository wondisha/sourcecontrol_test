CREATE TABLE [dbo].[Invoices]
(
[InvoiceID] [int] NOT NULL IDENTITY(1, 1),
[Title] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OrderDate] [date] NULL,
[Qty] [int] NULL,
[Total] [money] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Invoices] ADD CONSTRAINT [PK__Invoices__D796AAD5F0038E0C] PRIMARY KEY CLUSTERED ([InvoiceID]) WITH (FILLFACTOR=70) ON [PRIMARY]
GO
