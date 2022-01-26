SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

---
---	SELECT qpi.t(-21015) => GETDATE() - ( 2 days 10 hours 15 min)
---
CREATE    FUNCTION [qpi].[t](@time int)
RETURNS datetime2
AS BEGIN RETURN DATEADD(DAY, ((@time /10000) %100),
					DATEADD(HOUR, (@time /100) %100,
						DATEADD(MINUTE, (@time %100), GETDATE())
						)
					) END;
GO
