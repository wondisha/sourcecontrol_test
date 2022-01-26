CREATE TABLE [dbo].[DimCurrency]
(
[CurrencyKey] [int] NOT NULL IDENTITY(1, 1) NOT FOR REPLICATION,
[CurrencyAlternateKey] [nchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[CurrencyName] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[DimCurrency] ADD CONSTRAINT [PK_DimCurrency_CurrencyKey] PRIMARY KEY CLUSTERED ([CurrencyKey]) ON [PRIMARY]
GO
CREATE UNIQUE NONCLUSTERED INDEX [AK_DimCurrency_CurrencyAlternateKey] ON [dbo].[DimCurrency] ([CurrencyAlternateKey]) ON [PRIMARY]
GO
