SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

---
---	SELECT qpi.ago(2,10,15) => GETUTCDATE() - ( 2 days 10 hours 15 min)
---
CREATE    FUNCTION [qpi].[ago](@days tinyint, @hours tinyint, @min tinyint)
RETURNS datetime2
AS BEGIN RETURN DATEADD(day, - @days,
					DATEADD(hour, - @hours,
						DATEADD(minute, - @min, GETUTCDATE())
						)
					) END;
GO
