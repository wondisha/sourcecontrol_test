SET QUOTED_IDENTIFIER OFF
GO
SET ANSI_NULLS ON
GO

-- See for math: blogs.msdn.microsoft.com/psssql/2013/09/23/interpreting-the-counter-values-from-sys-dm_os_performance_counters/
CREATE    FUNCTION
[qpi].[fn_perf_counters](@as_of DATETIME2)
RETURNS TABLE
RETURN (
WITH
perf_counters AS
(
	select counter_name = counter_name COLLATE Latin1_General_100_CI_AS, cntr_value,
	 object_name = object_name COLLATE Latin1_General_100_CI_AS,
	 instance_name = instance_name COLLATE Latin1_General_100_CI_AS,
	  cntr_type, start_time = '9999-12-31 23:59:59.9999999' -- #hack used to join with prev.end_time
	from sys.dm_os_performance_counters
	WHERE @as_of is null
	union all
	select	counter_name = name COLLATE Latin1_General_100_CI_AS, cntr_value = value,
	object_name = object COLLATE Latin1_General_100_CI_AS,
	instance_name = instance_name COLLATE Latin1_General_100_CI_AS, cntr_type = type, start_time
	from qpi.os_performance_counters_snapshot for system_time as of @as_of
	WHERE @as_of is not null
),
perf_counters_prev AS
(
	select	counter_name = name, cntr_value = value, object_name = object, instance_name, cntr_type = type, start_time, end_time
	from qpi.os_performance_counters_snapshot for system_time all
	-- WHERE @as_of is null
	-- union all
	-- select	counter_name = name, cntr_value = value, object_name = object, instance_name, cntr_type = type, start_time, end_time
	-- from qpi.os_performance_counters_snapshot_history -- for system_time as of @as_of
	-- WHERE @as_of is not null
),
perf_counter_calculation AS (
--  PERF_COUNTER_RAWCOUNT, PERF_COUNTER_LARGE_RAWCOUNT -> NO PERF_LARGE_RAW_BASE (1073939712) because it is used just to calculate others.
select	name = counter_name, value = cntr_value, object = object_name, instance_name = pc.instance_name,
		type = cntr_type
from perf_counters pc
where cntr_type in (65536, 65792)
and pc.cntr_value > 0
--  /End:	PERF_COUNTER_RAWCOUNT, PERF_COUNTER_LARGE_RAWCOUNT
union all
-- PERF_LARGE_RAW_FRACTION
select	name = pc.counter_name,
		value =
			CASE
				WHEN base.cntr_value = 0 THEN NULL
				ELSE 100*pc.cntr_value/base.cntr_value
			END, object = pc.object_name,
		instance_name = pc.instance_name,
		type = pc.cntr_type
from (
	select counter_name, cntr_value, object_name, instance_name, cntr_type
	from perf_counters
	where cntr_type = 537003264 -- PERF_LARGE_RAW_FRACTION
	) as pc
	join (
	select counter_name, cntr_value, object_name, instance_name, cntr_type
	from perf_counters
	where cntr_type = 1073939712 -- PERF_LARGE_RAW_BASE
	) as base
		on  (rtrim(pc.counter_name) + ' base') COLLATE Latin1_General_100_CI_AS = (base.counter_name) COLLATE Latin1_General_100_CI_AS
		and  (pc.instance_name) COLLATE Latin1_General_100_CI_AS = (base.instance_name) COLLATE Latin1_General_100_CI_AS
		and  (pc.object_name) COLLATE Latin1_General_100_CI_AS = (base.object_name) COLLATE Latin1_General_100_CI_AS
-- /End: PERF_LARGE_RAW_FRACTION
union all
-- PERF_COUNTER_BULK_COUNT
select	name = pc.counter_name,
		value = (pc.cntr_value-prev.cntr_value)
				/(DATEDIFF_BIG(millisecond, prev.start_time, CASE prev.end_time
																WHEN '9999-12-31 23:59:59.9999999' THEN GETUTCDATE()
																ELSE prev.end_time	END) / 1000.),
		object = pc.object_name,
		instance_name = pc.instance_name,
		type = pc.cntr_type
from perf_counters pc
	join perf_counters_prev prev
		on  (pc.counter_name) COLLATE Latin1_General_100_CI_AS = (prev.counter_name) COLLATE Latin1_General_100_CI_AS
		and  (pc.object_name) COLLATE Latin1_General_100_CI_AS = (prev.object_name) COLLATE Latin1_General_100_CI_AS
		and  (pc.instance_name) COLLATE Latin1_General_100_CI_AS = (prev.instance_name) COLLATE Latin1_General_100_CI_AS
		and pc.cntr_type = prev.cntr_type
		and pc.start_time = prev.end_time
where pc.cntr_type = 272696576 -- PERF_COUNTER_BULK_COUNT
union ALL
-- PERF_AVERAGE_BULK
select	name = A1.counter_name,
		value =  CASE
		WHEN (B2.cntr_value = B1.cntr_value) THEN NULL
		ELSE (A2.cntr_value - A1.cntr_value) / (B2.cntr_value - B1.cntr_value)
		END,
		object = A1.object_name,
		A1.instance_name,
		type = A1.cntr_type
from perf_counters A1
	join perf_counters B1
		on CHARINDEX( REPLACE(REPLACE(RTRIM(B1.counter_name COLLATE Latin1_General_100_CI_AS), ' base',""), ' bs', ""), A1.counter_name) > 0
		and  (A1.instance_name) COLLATE Latin1_General_100_CI_AS = (B1.instance_name) COLLATE Latin1_General_100_CI_AS
		and  (A1.object_name) COLLATE Latin1_General_100_CI_AS = (B1.object_name) COLLATE Latin1_General_100_CI_AS
	join perf_counters A2
		on  (A1.counter_name) COLLATE Latin1_General_100_CI_AS = (A2.counter_name) COLLATE Latin1_General_100_CI_AS
		and  (A1.object_name) COLLATE Latin1_General_100_CI_AS = (A2.object_name) COLLATE Latin1_General_100_CI_AS
		and  (A1.instance_name) COLLATE Latin1_General_100_CI_AS = (A2.instance_name) COLLATE Latin1_General_100_CI_AS
		and A1.cntr_type = A2.cntr_type
	join perf_counters B2
		on CHARINDEX( REPLACE(REPLACE(RTRIM(B2.counter_name COLLATE Latin1_General_100_CI_AS), ' base',""), ' bs', ""), A2.counter_name) > 0
		and  (A2.instance_name) COLLATE Latin1_General_100_CI_AS = (B2.instance_name) COLLATE Latin1_General_100_CI_AS
		and  (A2.object_name) COLLATE Latin1_General_100_CI_AS = (B2.object_name) COLLATE Latin1_General_100_CI_AS
where A1.cntr_type = 1073874176 -- PERF_AVERAGE_BULK
and B1.cntr_type = 1073939712 -- PERF_LARGE_RAW_BASE
and A2.cntr_type = 1073874176 -- PERF_AVERAGE_BULK
and B2.cntr_type = 1073939712 -- PERF_LARGE_RAW_BASE
)
SELECT	name= RTRIM(pc.name), pc.value, type = RTRIM(pc.type), category = RTRIM(pc.object),
		instance_name =

			RTRIM(ISNULL(d.name, pc.instance_name))
FROM perf_counter_calculation pc

left join sys.databases d
			on  (pc.instance_name) COLLATE Latin1_General_100_CI_AS = (d.physical_database_name) COLLATE Latin1_General_100_CI_AS

WHERE value > 0
)
GO
