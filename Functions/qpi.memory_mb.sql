SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO
CREATE    FUNCTION [qpi].[memory_mb]()
RETURNS int AS
BEGIN
 RETURN (SELECT process_memory_limit_mb FROM sys.dm_os_job_object);
END
GO
