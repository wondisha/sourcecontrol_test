SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    VIEW [qpi].[memory]
AS
SELECT memory = REPLACE(ISNULL([type],'-->  TOTAL USED:'), 'MEMORYCLERK_', "")
     , gb = CAST(sum(pages_kb)/1024.1/1024 AS NUMERIC(6,1))
	 , perc = CAST(sum(pages_kb)/10.24/ qpi.memory_mb() AS TINYINT)
   FROM sys.dm_os_memory_clerks
   GROUP BY type WITH ROLLUP
   HAVING sum(pages_kb) /1024. /1024 > 0.1
UNION ALL
	SELECT memory = '-->  TOTAL AVAILABLE:',
		gb = CAST(ROUND(qpi.memory_mb() /1024., 1) AS NUMERIC(6,1)),
		perc = 100;
GO
