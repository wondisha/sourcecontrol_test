SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

CREATE    PROCEDURE [qpi].[snapshot_perf_counters]
AS BEGIN
MERGE qpi.os_performance_counters_snapshot AS Target
USING (
	SELECT object = object_name, name = counter_name, value = cntr_value, type = cntr_type,
	instance_name
	FROM sys.dm_os_performance_counters
	-- Do not use the trick with joining instance name with sys.databases.physical_name
	-- because there are duplicate key insert error on system database
	) AS Source
ON (	 (Target.object) COLLATE Latin1_General_100_CI_AS = (Source.object) COLLATE Latin1_General_100_CI_AS
	AND  (Target.name) COLLATE Latin1_General_100_CI_AS = (Source.name) COLLATE Latin1_General_100_CI_AS
	AND  (Target.instance_name) COLLATE Latin1_General_100_CI_AS = (Source.instance_name) COLLATE Latin1_General_100_CI_AS
	AND Target.type = Source.type)
WHEN MATCHED THEN
UPDATE SET
	Target.value = Source.value
WHEN NOT MATCHED BY TARGET THEN
INSERT (name, value, object, instance_name, type)
VALUES (Source.name,Source.value,Source.object,instance_name,Source.type)
;
END
GO
