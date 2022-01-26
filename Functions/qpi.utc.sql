SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
---
---	SELECT qpi.utc(-21015) => GETUTCDATE() - ( 2 days 10 hours 15 min)
---
CREATE    FUNCTION [qpi].[utc](@time int)
RETURNS datetime2
AS BEGIN RETURN DATEADD(DAY, ((@time /10000) %100),
					DATEADD(HOUR, (@time /100) %100,
						DATEADD(MINUTE, (@time %100), GETUTCDATE())
						)
					) END;
GO
