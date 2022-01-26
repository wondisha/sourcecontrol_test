SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    VIEW [qpi].[db_file_stats]
AS SELECT * from qpi.fn_file_stats(DB_ID(), null, null);
GO
