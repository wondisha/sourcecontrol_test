SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

-----------------------------------------------------------------------------
-- Core Database Query Store functionalities
-----------------------------------------------------------------------------
CREATE    FUNCTION [qpi].[decode_options](@options int)
RETURNS TABLE
RETURN (
SELECT 'DISABLE_DEF_CNST_CHK'  = (1 & @options) / 1
	, 'IMPLICIT_TRANSACTIONS' = (2 & @options) / 2
	, 'CURSOR_CLOSE_ON_COMMIT' = (4 & @options) / 4
	, 'ANSI_WARNINGS' = (8 & @options) / 8
	, 'ANSI_PADDING' = (16 & @options) / 16
	, 'ANSI_NULLS' = (32 & @options) / 32
	, 'ARITHABORT' = (64 & @options) / 64
	, 'ARITHIGNORE' = (128 & @options) / 128
	, 'QUOTED_IDENTIFIER' = (256 & @options) / 256
	, 'NOCOUNT' = (512 & @options) / 512
	, 'ANSI_NULL_DFLT_ON' = (1024 & @options) / 1024
	, 'ANSI_NULL_DFLT_OFF' = (2048 & @options) / 2048
	, 'CONCAT_NULL_YIELDS_NULL' = (4096 & @options) / 4096
	, 'NUMERIC_ROUNDABORT' = (8192 & @options) / 8192
	, 'XACT_ABORT' = (16384 & @options) / 16384
)
GO
