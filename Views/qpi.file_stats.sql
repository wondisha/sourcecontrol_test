SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    VIEW [qpi].[file_stats]
AS SELECT * from qpi.fn_file_stats(null, null, null);
GO
